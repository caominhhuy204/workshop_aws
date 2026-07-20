---
title: "Phát hiện và phản ứng sự cố"
date: 2026-07-20
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

# Phát hiện và phản ứng sự cố bảo mật

## Xử lý kết quả Malware Protection

EventBridge nhận **GuardDuty Malware Protection Object Scan Result**. Lambda phải xác minh bucket và prefix trước khi xử lý.

Trước khi kiểm thử upload, xác nhận bucket tài liệu xuất hiện trong **GuardDuty → Malware Protection for S3 → Protected buckets** với trạng thái **Active** và đúng prefix cần quét.

![GuardDuty Malware Protection for S3 đang bảo vệ bucket tài liệu](/5-workshop/document-security/img-15-guardduty-malware-protection.png)

- `NO_THREATS_FOUND`: phát hành object, đặt `CLEAN`, bật download, ghi audit và xóa đúng staging version.
- `THREATS_FOUND`: đặt `INFECTED`, khóa download, lưu tên threat, tạo incident, gửi SNS và giữ object trong quarantine.
- Kết quả lỗi/không xác định: đặt `SCAN_FAILED`, lưu lý do và tiếp tục khóa download theo nguyên tắc fail closed.

Khi kiểm thử, file `clean-scan-test-2.txt` được đánh dấu **Clean** và có thể Download. File kiểm thử `eicar.com.txt` được đánh dấu **Infected**, vì vậy nút Download bị vô hiệu hóa và file tiếp tục nằm trong vùng cách ly.

![Kết quả quét file sạch và file EICAR bị nhiễm](/5-workshop/document-security/img-16-clean-eicar-results.png)

Khi phát hiện object chứa mã độc, Lambda tạo incident loại `Object:S3/MaliciousFile`. Incident lưu mức độ `HIGH`, trạng thái `OPEN`, S3 resource và mã malware để quản trị viên tiếp tục điều tra.

![Danh sách incident Object S3 MaliciousFile ở mức High](/5-workshop/document-security/img-17-malware-incidents.png)

## Luồng GuardDuty finding

1. GuardDuty tạo finding và EventBridge bắt sự kiện.
2. Step Functions gọi `SecurityIncidentResponse`.
3. Lambda chuẩn hóa severity, ghi incident và gửi SNS.
4. Với EC2 đạt ngưỡng và nằm trong allowlist, workflow chuyển sang chờ phê duyệt.
5. Người phê duyệt chọn `QUARANTINE`, `STOP` hoặc `REJECT`.
6. Lambda chỉ thực hiện hành động sau khi callback hợp lệ.

Trang **Incidents** tự động làm mới và tập trung các sự cố từ S3, IAM và EC2. Quản trị viên có thể lọc theo severity, status hoặc finding type, sau đó chọn một incident để xem AWS context và hành động phù hợp.

![Incident stream tổng hợp các finding S3 IAM và EC2](/5-workshop/document-security/img-18-incident-stream.png)

Khi chọn một incident EC2, bảng chi tiết hiển thị finding type, severity, status, Region và instance liên quan. Admin có thể yêu cầu cách ly, khôi phục Security Group, dừng EC2 khẩn cấp hoặc cập nhật trạng thái điều tra.

![Chi tiết incident EC2 và các hành động phản ứng dành cho Admin](/5-workshop/document-security/img-18-incident-detail-actions.png)

## Human approval

Step Functions sử dụng `waitForTaskToken` với timeout 86.400 giây. Approval Notifier tạo ba liên kết và gửi qua SNS. API Gateway cung cấp `ANY /approval` đến Approval Callback.

State machine trước tiên xử lý GuardDuty finding, xác định có cần phê duyệt hay không và chuyển execution sang `WaitForSecurityApproval`. Sau khi nhận callback, `RouteDecision` chọn nhánh Quarantine, Stop, Reject hoặc kết thúc không cần approval.

![Graph view của Step Functions điều phối phản ứng và phê duyệt](/5-workshop/document-security/img-20-step-functions-graph.png)

Luồng xác nhận gồm hai bước:

1. `GET` hiển thị nội dung incident và quyết định, chưa thay đổi tài nguyên.
2. Người dùng xác nhận bằng `POST`; Lambda gọi `SendTaskSuccess`.
3. State machine rẽ nhánh theo quyết định.
4. Token hết hạn, không tồn tại hoặc đã dùng trả HTTP `409`.

## Hành động phản ứng

- **Quarantine:** lưu Security Group gốc, thay SG trên primary ENI bằng Quarantine SG và chuyển incident sang `INVESTIGATING`.
- **Restore:** gắn lại danh sách SG gốc, tag instance `Restored` và chuyển incident sang `RESOLVED`.
- **Stop:** gọi `StopInstances` sau khi phê duyệt và lưu đầy đủ actor/thời gian.

## Kiểm soát an toàn

- Chỉ Admin được gọi API phản ứng.
- Instance phải thuộc `ALLOWED_INSTANCE_IDS` và không thuộc `PROTECTED_INSTANCE_IDS`.
- Quarantine SG phải cùng VPC với ENI.
- Lưu SG gốc trước khi thay đổi.
- Mọi hành động phải cập nhật DynamoDB, audit và gửi thông báo.

{{% notice warning %}}
Không tự động dừng hoặc cách ly EC2 chỉ dựa trên finding trong môi trường production. Luôn giữ bước phê duyệt và kiểm tra phạm vi ảnh hưởng.
{{% /notice %}}
