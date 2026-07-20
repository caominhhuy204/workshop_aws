---
title: "Blog 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---
{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

# Xây dựng Upload File Service trên AWS với Presigned URL

## 1. Tổng quan nội dung nghiên cứu

Trong quá trình tìm hiểu kiến trúc ứng dụng trên AWS, một bài toán phổ biến là xây dựng chức năng upload file cho web hoặc mobile application. Ban đầu, cách tiếp cận dễ nghĩ đến là để client gửi file lên backend, sau đó backend tiếp nhận file và lưu xuống Amazon S3.

Tuy nhiên, khi số lượng người dùng tăng hoặc kích thước file lớn hơn, cách làm này khiến backend phải xử lý nhiều dữ liệu không cần thiết. Backend vừa phải nhận file, vừa phải truyền file sang S3, dẫn đến tăng tải hệ thống, tăng độ trễ và có thể làm chi phí vận hành cao hơn.

Giải pháp được AWS khuyến nghị là sử dụng **Presigned URL** kết hợp với các dịch vụ serverless như Amazon API Gateway, AWS Lambda và Amazon S3. Với cách này, backend chỉ xác thực người dùng và tạo URL upload tạm thời, còn client sẽ upload file trực tiếp lên S3.

![Kiến trúc upload file lên S3 bằng Presigned URL](/images/blog2-s3-presigned-url.jpg)

## 2. Vấn đề của cách upload thông qua backend

Nếu toàn bộ file đều đi qua backend, hệ thống có thể gặp một số hạn chế:

* Backend phải xử lý dung lượng dữ liệu lớn dù không trực tiếp sử dụng nội dung file.
* Thời gian phản hồi API có thể tăng khi file lớn hoặc có nhiều request đồng thời.
* Cần mở rộng backend chỉ để phục vụ luồng upload dữ liệu.
* Việc xử lý lỗi, timeout và retry phức tạp hơn.
* Chi phí compute và băng thông có thể tăng không cần thiết.

Vì vậy, trong nhiều hệ thống hiện đại, backend không nên là nơi trung chuyển toàn bộ dữ liệu file. Thay vào đó, backend nên giữ vai trò kiểm soát nghiệp vụ, xác thực và cấp quyền upload.

## 3. Giải pháp sử dụng Presigned URL

Presigned URL là một URL tạm thời được tạo bởi AWS để cho phép client thực hiện một thao tác cụ thể với Amazon S3 trong một khoảng thời gian giới hạn. URL này có thể được dùng để upload hoặc download object mà không cần cấp quyền AWS trực tiếp cho người dùng cuối.

Trong kiến trúc upload file, luồng xử lý cơ bản như sau:

| Bước | Thành phần | Nội dung xử lý |
| --- | --- | --- |
| 1 | Client | Gửi yêu cầu lấy URL upload |
| 2 | Amazon API Gateway | Tiếp nhận request từ client |
| 3 | AWS Lambda | Xác thực người dùng và tạo Presigned URL |
| 4 | Amazon S3 | Nhận file upload trực tiếp từ client |
| 5 | S3 Event hoặc EventBridge | Phát sinh sự kiện khi object được tạo |
| 6 | Lambda Processor | Xử lý file sau upload |
| 7 | DynamoDB, SNS, CloudWatch | Lưu metadata, gửi thông báo và ghi nhận log giám sát |

Điểm quan trọng của kiến trúc này là AWS Lambda không xử lý trực tiếp dữ liệu file. Lambda chỉ tạo Presigned URL dựa trên quyền IAM được cấu hình, sau đó client dùng URL này để upload trực tiếp lên S3.

## 4. Vai trò của các dịch vụ AWS

### 4.1. Amazon API Gateway

Amazon API Gateway đóng vai trò là điểm vào của hệ thống. Client gửi request đến API Gateway để yêu cầu tạo URL upload. API Gateway giúp quản lý endpoint, xác thực, phân quyền, giới hạn request và kết nối đến Lambda phía sau.

### 4.2. AWS Lambda

AWS Lambda xử lý logic nghiệp vụ như kiểm tra người dùng, kiểm tra loại file, giới hạn kích thước file và tạo Presigned URL. Vì Lambda không nhận file trực tiếp nên thời gian xử lý ngắn hơn và chi phí compute được tối ưu hơn.

### 4.3. Amazon S3

Amazon S3 là nơi lưu trữ file sau khi client upload. S3 có khả năng mở rộng cao, độ bền dữ liệu lớn và phù hợp với nhiều loại file như hình ảnh, tài liệu, video hoặc dữ liệu ứng dụng.

### 4.4. AWS IAM

AWS IAM kiểm soát quyền giữa các dịch vụ. Lambda cần được cấp quyền phù hợp để tạo Presigned URL cho bucket S3. Quyền IAM nên được thiết kế theo nguyên tắc least privilege, chỉ cho phép thao tác cần thiết với bucket hoặc prefix tương ứng.

### 4.5. Amazon EventBridge và S3 Event Notification

Sau khi file được upload thành công, S3 có thể phát sinh event. Event này có thể kích hoạt Lambda khác hoặc gửi qua EventBridge để thực hiện các tác vụ xử lý sau upload.

## 5. Xử lý sau khi upload thành công

Upload file lên S3 chưa phải là điểm kết thúc của hệ thống. Sau khi object được tạo, hệ thống có thể tiếp tục thực hiện nhiều tác vụ bất đồng bộ như:

* Resize hình ảnh.
* Quét virus hoặc kiểm tra nội dung file.
* Lưu metadata vào DynamoDB.
* Gửi thông báo qua Amazon SNS.
* Ghi log và theo dõi bằng Amazon CloudWatch.
* Tạo thumbnail hoặc phiên bản tối ưu cho hiển thị.

Việc tách upload và xử lý sau upload giúp hệ thống dễ mở rộng hơn. Người dùng không phải chờ toàn bộ quá trình xử lý hoàn tất, trong khi backend vẫn có thể xử lý các tác vụ bổ sung ở phía sau.

## 6. Lợi ích của kiến trúc serverless

Kiến trúc này là một ví dụ điển hình về cách AWS khuyến khích chia nhỏ trách nhiệm cho từng dịch vụ:

* API Gateway tiếp nhận và quản lý request.
* Lambda xử lý logic nghiệp vụ và tạo URL upload.
* S3 lưu trữ file trực tiếp từ client.
* EventBridge hoặc S3 Event Notification kích hoạt xử lý sau upload.
* DynamoDB lưu metadata.
* SNS gửi thông báo.
* CloudWatch hỗ trợ log và giám sát.

Nhờ cách phân tách này, hệ thống vừa đơn giản hơn, vừa có khả năng mở rộng tự nhiên theo tải thực tế mà không cần quản lý máy chủ.

## 7. Lưu ý khi triển khai

Khi triển khai upload file bằng Presigned URL, cần chú ý một số điểm sau:

* Thiết lập thời gian hết hạn của URL phù hợp để tránh lạm dụng.
* Giới hạn loại file và kích thước file được phép upload.
* Sử dụng IAM policy tối thiểu quyền cho Lambda.
* Cấu hình CORS cho bucket S3 nếu client là web application.
* Không để client tự quyết định key object một cách tùy ý nếu có rủi ro ghi đè file.
* Bật log và giám sát bằng CloudWatch để theo dõi lỗi upload.
* Kết hợp kiểm tra bảo mật sau upload nếu file đến từ người dùng bên ngoài.

## 8. Kết luận

Việc sử dụng Presigned URL giúp xây dựng chức năng upload file hiệu quả hơn trên AWS. Backend không cần xử lý trực tiếp dữ liệu file, từ đó giảm tải hệ thống, giảm độ trễ và tận dụng tốt khả năng mở rộng của Amazon S3.

Đối với các ứng dụng web hoặc mobile, kiến trúc kết hợp API Gateway, Lambda, S3, EventBridge và các dịch vụ xử lý sau upload là một hướng triển khai serverless linh hoạt, dễ mở rộng và tối ưu chi phí. Đây là một mô hình đáng tham khảo khi xây dựng hệ thống upload file trên AWS.

**Tài liệu tham khảo:** <https://aws.amazon.com/blogs/compute/uploading-to-amazon-s3-directly-from-a-web-or-mobile-application/>
