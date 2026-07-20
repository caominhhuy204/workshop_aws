---
title: "Các bài blog đã đăng"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

{{% notice warning %}}  
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

Phần này tổng hợp các bài blog kỹ thuật đã thực hiện trong quá trình thực tập. Nội dung tập trung vào các chủ đề AWS Cloud liên quan đến giám sát bảo mật, kiến trúc serverless và khả năng mở rộng hệ thống.

### [Blog 1 - Giám sát bảo mật Amazon S3 bằng Amazon CloudWatch Logs](3.1-Blog1/)

Bài viết trình bày cách tích hợp Amazon S3 Server Access Logs với Amazon CloudWatch Logs để xây dựng dashboard giám sát bảo mật. Nội dung tập trung vào việc chuyển log S3 thành dữ liệu có cấu trúc, truy vấn bằng CloudWatch Logs Insights, tạo cảnh báo bằng Metric Filters và hỗ trợ phát hiện bất thường trong truy cập dữ liệu.

### [Blog 2 - Xây dựng Upload File Service trên AWS với Presigned URL](3.2-Blog2/)

Bài viết phân tích kiến trúc upload file trực tiếp lên Amazon S3 bằng Presigned URL. Nội dung giới thiệu vai trò của Amazon API Gateway, AWS Lambda, Amazon S3, IAM và EventBridge trong việc giảm tải backend, xử lý file sau upload và xây dựng hệ thống serverless linh hoạt hơn.

### [Blog 3 - Amazon EC2 Auto Scaling Group trong kiến trúc AWS](3.3-Blog3/)

Bài viết giới thiệu Amazon EC2 Auto Scaling Group và vai trò của dịch vụ này trong việc tự động mở rộng, tự phục hồi và duy trì tính sẵn sàng cho ứng dụng. Nội dung cũng phân tích cách Auto Scaling Group kết hợp với Amazon CloudWatch và Application Load Balancer để vận hành hệ thống ổn định hơn.
