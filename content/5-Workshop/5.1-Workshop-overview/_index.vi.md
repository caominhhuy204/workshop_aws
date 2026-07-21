---
title: "Tổng quan Workshop"
date: 2026-07-20
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

# Tổng quan Workshop

## Bài toán

Tài liệu nội bộ có thể chứa dữ liệu nghiệp vụ, thông tin cá nhân hoặc nội dung nhạy cảm. Lưu file trên máy chủ thông thường dễ dẫn đến mất dữ liệu, truy cập trái phép, tải xuống file nhiễm mã độc, mất lịch sử phiên bản và thiếu bằng chứng kiểm toán.

Document Security giải quyết bài toán bằng kiến trúc bảo mật nhiều lớp:

- Bucket tài liệu và frontend đều private.
- Trình duyệt không giữ AWS access key.
- File được kiểm tra loại và giới hạn 20 MB ở cả frontend lẫn backend.
- File mới nằm trong quarantine/ và chỉ được tải xuống sau khi có trạng thái CLEAN.
- S3 Versioning, Recycle bin và bảng audit bảo vệ vòng đời tài liệu.
- GuardDuty findings tạo incident; hành động cách ly hoặc dừng EC2 cần phê duyệt.
- Log, metric và lịch sử hành động được tập trung để điều tra và kiểm toán.

## Kết quả sau Workshop

Bạn sẽ có thể:

1. Phân phối SPA riêng tư qua CloudFront và Origin Access Control.
2. Xác thực bằng Cognito, phân quyền User/Admin ở backend.
3. Upload, quét, tải xuống, tạo phiên bản, xóa mềm và khôi phục tài liệu.
4. Ghi nhận malware scan và GuardDuty finding thành incident.
5. Điều phối Human approval bằng Step Functions, SNS và API Gateway.
6. Cách ly, khôi phục Security Group hoặc dừng EC2 trong phạm vi cho phép.
7. Theo dõi hệ thống bằng CloudWatch và Grafana.

## Kiến trúc tổng thể

![Sơ đồ kiến trúc tổng thể của hệ thống Document Security trên AWS](/5-workshop/document-security/img-01-architecture.png)

Người dùng truy cập ứng dụng qua AWS WAF và Amazon CloudFront. Frontend được phân phối từ Amazon S3, Amazon Cognito đảm nhiệm xác thực và backend chạy trên Amazon EC2. Tài liệu được lưu trên Amazon S3, còn metadata và incident được lưu trong Amazon DynamoDB.

CloudTrail, AWS Config và CloudWatch cung cấp nguồn nhật ký và sự kiện. GuardDuty, Security Hub và EventBridge phát hiện, tổng hợp và chuyển tiếp sự cố. Step Functions, API Gateway và Lambda điều phối quy trình phản ứng; SNS gửi cảnh báo và Systems Manager hỗ trợ người vận hành truy cập tài nguyên an toàn.
