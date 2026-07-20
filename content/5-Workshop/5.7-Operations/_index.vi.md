---
title: "Vận hành và dọn dẹp"
date: 2026-07-20
weight: 7
chapter: false
pre: " <b> 5.7. </b> "
---

# Vận hành, xử lý sự cố và dọn dẹp

## Quy trình cập nhật frontend

1. Sửa source và chạy `npm run build`.
2. Upload `dist/` lên bucket frontend.
3. Đặt `no-cache` cho `index.html`.
4. Tạo CloudFront invalidation `/*`.
5. Chờ `Completed` và kiểm tra bằng cửa sổ ẩn danh.

## Quy trình khởi động lại

1. Start EC2 và chờ status checks `2/2`.
2. Kiểm tra IP/origin và Security Group.
3. Kiểm tra Nginx và backend service.
4. Gọi `/api/health` trực tiếp và qua CloudFront.
5. Đăng nhập, tải Documents/Incidents và kiểm tra log.

## Xử lý sự cố thường gặp

| Triệu chứng | Kiểm tra |
|---|---|
| CloudFront 504 ở `/api/` | EC2, origin, SG, Nginx và direct health |
| SPA 403/404 khi refresh | Custom error response về `/index.html` |
| Upload 413 | `client_max_body_size 20M` |
| File luôn Pending | Malware Protection, EventBridge và Lambda logs |
| Download 423 | `scanstatus` và scan event |
| Recycle bin không Recover | Latest S3 Delete Marker và DynamoDB |
| Approval 409 | Token đã dùng hoặc workflow timeout |
| Quarantine thất bại | Allowlist, protected list, VPC và SG |
| Grafana No data | Region, IAM role và time range |
| Giao diện cũ | CloudFront invalidation và browser cache |

## Nguồn chi phí

Theo dõi EC2/EBS/EIP, S3 versions và request, CloudFront, DynamoDB, GuardDuty/Malware Protection/Security Hub, Lambda/EventBridge/Step Functions/API Gateway/SNS và CloudWatch Logs.

Cost Explorer được cấu hình **Group by: Service** để phân tích đóng góp chi phí của EC2, VPC, Security Hub, AWS Config, S3, Secrets Manager, CloudWatch và các dịch vụ khác. Ảnh dưới đây thể hiện chi phí theo tháng trước khi dọn dẹp tài nguyên.

![Cost Explorer hiển thị chi phí AWS theo dịch vụ](/5-workshop/document-security/img-30-cost-explorer.png)

## Dọn dẹp tài nguyên

{{% notice danger %}}
Chỉ dọn dẹp sau khi đã sao lưu dữ liệu và chụp đủ bằng chứng. Xóa S3 versions, DynamoDB hoặc log có thể không khôi phục được.
{{% /notice %}}

1. Disable EventBridge rules và dừng Step Functions executions đang chờ.
2. Xuất dữ liệu/audit cần giữ.
3. Xóa Lambda, API Gateway, SNS và các role riêng của lab.
4. Disable rồi xóa CloudFront khi trạng thái cho phép.
5. Xóa toàn bộ S3 object versions và Delete Markers trước khi xóa bucket.
6. Xóa DynamoDB tables, log groups và alarms không cần giữ.
7. Terminate EC2; kiểm tra EBS, EIP, ENI và Security Group còn sót.
8. Chỉ tắt GuardDuty/Security Hub nếu tài khoản không còn nhu cầu bảo vệ.

Cuối cùng, mở Cost Explorer và Resource Explorer/Tag Editor để xác nhận không còn tài nguyên phát sinh chi phí.
