---
title: "Giám sát và kiểm thử"
date: 2026-07-20
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

# Giám sát, kiểm thử và đánh giá bảo mật

## CloudWatch và Grafana

Thu thập các log group cho Nginx, system và bốn Lambda xử lý incident/malware/approval. Theo dõi metric của EC2, Lambda, DynamoDB, S3, EventBridge, SNS, Step Functions và CloudFront.

Dashboard DocumentApp-Monitoring hiển thị các chỉ số vận hành chính của backend EC2. Memory và Disk được CloudWatch Agent gửi dưới dạng custom metrics, còn CPUUtilization đến từ metric mặc định của EC2.

![CloudWatch dashboard theo dõi Memory Disk và CPU của backend](/5-workshop/document-security/img-27-cloudwatch-dashboard.png)

Log Management tập trung log của bốn Lambda, VPC Flow Logs, Nginx access/error và system. Môi trường lab đặt retention một hoặc hai tuần cho log hạ tầng để kiểm soát chi phí; các Lambda log groups cần được cấu hình retention phù hợp thay vì giữ vô thời hạn khi triển khai lâu dài.

![Danh sách CloudWatch Log groups của hệ thống](/5-workshop/document-security/img-27-cloudwatch-log-groups.png)

Grafana sử dụng CloudWatch data source tại ap-southeast-1 với IAM role read-only. Truy cập qua SSM port forwarding, không mở TCP 3000 public:

```bash
aws ssm start-session \
  --target <ec2-instance-id> \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["3000"],"localPortNumber":["3000"]}'
```

Sau đó mở http://localhost:3000.

Dashboard **Document App - AWS Services Monitoring** tổng hợp Lambda invocations/errors/duration/throttles, DynamoDB read/write/system errors cùng metric S3 và SNS trong một màn hình vận hành.

![Grafana AWS Services Monitoring của Document App](/5-workshop/document-security/img-28-grafana-aws-services.png)

Dashboard **Document App - Security Logs Monitoring** tập trung HTTP requests, 4xx/5xx responses, Lambda log events, Security Incident Response logs và Nginx access logs để hỗ trợ điều tra.

![Grafana Security Logs Monitoring của Document App](/5-workshop/document-security/img-28-grafana-security-logs.png)

## Bằng chứng kiểm toán

| Nguồn | Bằng chứng |
|---|---|
| CloudTrail | Lịch sử management API |
| VPC Flow Logs | Network ACCEPT/REJECT trên ENI |
| S3 Server Access Logging | Request truy cập bucket |
| AWS Config | Thay đổi cấu hình và compliance |
| DocumentVersionAudit | Hành động theo tài liệu/version |
| SecurityIncidents | Finding, trạng thái và phản ứng |

## Test case bắt buộc

| Nhóm | Kiểm thử | Kết quả mong đợi |
|---|---|---|
| Auth | Sai mật khẩu; User gọi API Admin | HTTP 401/403 |
| Upload | File hợp lệ, sai loại, trên 20 MB | Pending scan hoặc HTTP 400 |
| Malware | File sạch và EICAR | Clean mở download; Infected khóa và tạo incident |
| Download | File chưa sạch | HTTP 423 |
| Version | Bản sạch, bản nhiễm, restore | Không thay thế bản sạch bằng bản nhiễm |
| Delete | Soft delete, recover, permanent delete | Delete Marker/audit đúng; yêu cầu xác nhận |
| Incident | GuardDuty sample finding | Ghi incident và gửi SNS |
| Approval | Quarantine, restore, stop, dùng lại link | Hành động đúng; link dùng lại trả 409 |
| Health | Direct origin và CloudFront | Tất cả dependency OK |
| SPA | Refresh /login hoặc /incidents | Không trả 404 |

## Tiêu chí nghiệm thu

- Bucket không public; frontend chỉ qua CloudFront OAC.
- Download chỉ mở cho file CLEAN.
- User không gọi được API Admin.
- Versioning, Recycle bin và audit hoạt động.
- Finding tạo incident, cảnh báo và luồng phê duyệt.
- Không có hành động EC2 vượt allowlist/protected list.
- CloudWatch/Grafana có dữ liệu mới và CloudFront phục vụ ổn định.

## Đánh giá bảo mật

Điểm mạnh gồm credential tạm thời qua IAM role, kiểm tra quyền tại backend, quét fail closed, S3 Versioning, human approval và nhiều lớp audit. Khi triển khai production cần bổ sung domain/ACM, HTTPS origin, Secrets Manager hoặc Parameter Store, MFA, backup/PITR, lifecycle, WAF block rules và chiến lược DR đa Region.
