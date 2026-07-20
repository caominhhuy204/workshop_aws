---
title: "Blog 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---
{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

<style>
  article code,
  main code,
  .content code {
    color: #000 !important;
  }
</style>

# Giám sát bảo mật Amazon S3 bằng Amazon CloudWatch Logs

## 1. Tổng quan nội dung nghiên cứu

Trong quá trình tìm hiểu các giải pháp vận hành và giám sát bảo mật trên AWS, bài viết này tập trung vào cách tích hợp **Amazon S3 Server Access Logs** với **Amazon CloudWatch Logs**. Đây là một hướng tiếp cận giúp đội ngũ vận hành khai thác log truy cập S3 trực tiếp trong CloudWatch mà không cần tự xây dựng pipeline xử lý log phức tạp.

Amazon S3 Server Access Logs ghi lại chi tiết các request gửi đến bucket S3, bao gồm request thành công, request thất bại, request có xác thực và request ẩn danh. Các bản ghi này cung cấp nhiều thông tin quan trọng ở tầng HTTP như địa chỉ IP nguồn, requester, loại thao tác, trạng thái phản hồi, dung lượng truyền tải, phiên bản TLS và thông tin mã hóa.

Bên cạnh S3 Server Access Logs, AWS CloudTrail data events cũng là một nguồn dữ liệu quan trọng để giám sát thao tác ở cấp độ object như GetObject, PutObject và DeleteObject. Tuy nhiên, điểm nổi bật của S3 Server Access Logs là khả năng cung cấp góc nhìn chi tiết về request HTTP, giúp bổ sung thêm dữ liệu cho hoạt động điều tra, kiểm toán và phát hiện bất thường.

![Sơ đồ tích hợp S3 Access Logs với CloudWatch Logs](/images/blog1-s3-cloudwatch.jpg)

## 2. Vấn đề trước khi tích hợp CloudWatch

Trước đây, để khai thác giá trị bảo mật từ S3 access logs, đội ngũ vận hành thường phải tự thực hiện nhiều bước thủ công:

* Cấu hình bucket đích để lưu trữ log.
* Xây dựng pipeline ETL để đọc, parse và chuẩn hóa log.
* Quản lý lifecycle cho số lượng lớn file log nhỏ.
* Kết nối thêm công cụ phân tích, cảnh báo và dashboard.
* Tự xử lý việc tập trung log nếu hệ thống có nhiều account hoặc nhiều region.

Cách làm này tạo ra gánh nặng vận hành đáng kể, đặc biệt với tổ chức có nhiều bucket S3, nhiều môi trường triển khai và yêu cầu giám sát bảo mật liên tục.

## 3. Giải pháp được AWS đề xuất

Giải pháp mới cho phép Amazon S3 Server Access Logs trở thành một nguồn dữ liệu gốc của Amazon CloudWatch thông qua cơ chế **Vended Logs**. Thay vì phải đưa log về bucket riêng rồi tự xử lý, log có thể được chuyển vào CloudWatch Logs để phục vụ truy vấn, tạo metric, cảnh báo và dashboard.

Các thành phần chính của giải pháp gồm:

| Thành phần | Vai trò |
| --- | --- |
| Amazon S3 Server Access Logs | Ghi lại thông tin request đến bucket S3 |
| CloudWatch Logs | Tiếp nhận, lưu trữ và chuẩn hóa log |
| CloudWatch Logs Insights | Truy vấn log bằng cú pháp gần giống SQL |
| Metric Filters và Alarms | Biến mẫu log thành metric và cảnh báo tự động |
| Contributor Insights | Xếp hạng IP, requester hoặc bucket có hoạt động nổi bật |
| CloudWatch Pipelines | Chuẩn hóa dữ liệu log sang định dạng OCSF |
| Logs Centralization | Tập trung log từ nhiều account về một account giám sát |

## 4. Các điểm kỹ thuật nổi bật

### 4.1. Tự động chuyển đổi log sang JSON

Log S3 gốc thường ở dạng văn bản phân tách bằng khoảng trắng, gây khó khăn khi truy vấn trực tiếp. Khi được đưa vào CloudWatch Logs, dữ liệu có thể được chuyển thành JSON có cấu trúc, giúp việc truy vấn theo trường như remote_ip, http_status hoặc bytes_sent_size trở nên thuận tiện hơn.

### 4.2. Bật log trên quy mô lớn bằng Telemetry Enablement Rules

Telemetry Enablement Rules cho phép bật thu thập log theo phạm vi tổ chức, organizational unit hoặc từng account. Ngoài ra, có thể lọc theo tag để chỉ áp dụng cho những bucket cần giám sát, giúp triển khai nhanh và kiểm soát phạm vi rõ ràng.

### 4.3. Truy vấn bất thường bằng CloudWatch Logs Insights

CloudWatch Logs Insights hỗ trợ truy vấn log để phát hiện các hành vi đáng ngờ, ví dụ:

* Nhiều request bị từ chối với mã lỗi 403.
* Nhiều request không tìm thấy object với mã lỗi 404.
* Một IP tải xuống dung lượng dữ liệu bất thường.
* Request ẩn danh xuất hiện trên bucket nhạy cảm.
* Tỷ lệ lỗi 5xx tăng bất thường.

### 4.4. Cảnh báo tự động bằng Metric Filters và Alarms

Thay vì kiểm tra log thủ công, Metric Filters cho phép chuyển các mẫu log quan trọng thành CloudWatch metrics. Sau đó, CloudWatch Alarms có thể tự động cảnh báo khi vượt ngưỡng, ví dụ số lỗi 403/404 tăng đột biến hoặc xuất hiện request ẩn danh.

### 4.5. Xác định nguồn rủi ro bằng Contributor Insights

Contributor Insights giúp liên tục xếp hạng các đối tượng có hoạt động nhiều nhất như IP nguồn, requester hoặc bucket. Tính năng này hữu ích khi cần nhanh chóng xác định nguồn phát sinh truy cập bất thường hoặc hành vi có nguy cơ cao.

## 5. Ứng dụng thực tế

Giải pháp này có thể được áp dụng trong nhiều tình huống vận hành và bảo mật:

* **Giám sát truy cập trái phép:** tổng hợp lỗi 403 và 404 theo IP để phát hiện hành vi dò quét key hoặc brute-force.
* **Phát hiện rò rỉ dữ liệu:** theo dõi dung lượng tải xuống theo requester hoặc IP để nhận biết các phiên tải dữ liệu bất thường.
* **Theo dõi tuân thủ bảo mật:** kiểm tra phiên bản TLS, cấu hình mã hóa và kiểu xác thực của request.
* **Tạo dashboard bảo mật:** tổng hợp số request, lỗi, request ẩn danh, hoạt động xóa dữ liệu và các chỉ số truy cập quan trọng.
* **Tập trung giám sát đa account:** sao chép log từ các account con về account trung tâm để thuận tiện điều tra và kiểm toán.

## 6. Khả năng mở rộng của giải pháp

Giải pháp có tính linh hoạt cao vì không phụ thuộc vào một cấu trúc tổ chức cố định. Enablement Rules có thể áp dụng ở cấp tổ chức, OU hoặc account riêng lẻ. Khi kết hợp với tag, đội ngũ vận hành có thể bật log đúng phạm vi cần thiết thay vì áp dụng tràn lan cho toàn bộ tài nguyên.

Ngoài ra, việc hỗ trợ chuẩn hóa log sang **OCSF** giúp dữ liệu dễ tích hợp với các công cụ bảo mật, data lake hoặc hệ thống phân tích tập trung khác. Khi kết hợp S3 access logs với CloudTrail, VPC Flow Logs và log ứng dụng, tổ chức có thể xây dựng chiến lược giám sát theo chiều sâu trên cùng một nền tảng CloudWatch.

## 7. Hạn chế và lưu ý khi triển khai

Mặc dù giải pháp giúp đơn giản hóa vận hành, vẫn cần lưu ý một số điểm sau:

* **Độ trễ log:** S3 Server Access Logs được giao theo cơ chế best-effort, phần lớn log đến trong vài giờ, nên không phải giải pháp thời gian thực tuyệt đối.
* **Phạm vi dữ liệu:** Access log mạnh ở tầng HTTP nhưng không thay thế hoàn toàn CloudTrail data events về ngữ cảnh IAM.
* **Cấu hình phạm vi:** khi thay đổi enablement rule, cần rà soát lại các bucket đã cấu hình trước đó để tránh bỏ sót.
* **Chi phí:** chi phí thu thập log tăng theo khối lượng log phát sinh, nên cần chọn phạm vi bật log phù hợp.
* **Dọn dẹp tài nguyên:** sau thử nghiệm cần xóa dashboard, metric filter, alarm hoặc Contributor Insights rule không còn sử dụng.

## 8. Kết luận

Việc đưa Amazon S3 Server Access Logs vào Amazon CloudWatch Logs là một cải tiến quan trọng trong giám sát bảo mật cho hệ thống lưu trữ trên AWS. Giải pháp này giúp rút ngắn quá trình từ log thô đến dashboard bảo mật, giảm nhu cầu xây dựng pipeline riêng và hỗ trợ đội ngũ vận hành phát hiện bất thường nhanh hơn.

Đối với các hệ thống sử dụng Amazon S3 ở quy mô lớn, việc kết hợp S3 Server Access Logs, CloudWatch Logs, CloudWatch Logs Insights, Metric Filters và Contributor Insights có thể tạo nên một nền tảng giám sát hiệu quả cho bảo mật, kiểm toán và tuân thủ.

**Tài liệu tham khảo:** <https://aws.amazon.com/blogs/mt/using-amazon-s3-server-access-logs-with-amazon-cloudwatch-logs/>
