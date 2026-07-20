---
title: "Đề xuất dự án"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Hệ thống quản lý tài liệu an toàn trên AWS

## 1. Tổng quan

Dự án xây dựng hệ thống quản lý tài liệu trên AWS, cho phép người dùng đăng nhập, tải lên, tìm kiếm và tải xuống tài liệu an toàn. Hệ thống hỗ trợ quét mã độc, quản lý phiên bản, giám sát hoạt động và phản ứng sự cố bảo mật.

## 2. Vấn đề cần giải quyết

Tài liệu nội bộ có nguy cơ bị truy cập trái phép, nhiễm mã độc, xóa nhầm hoặc thiếu lịch sử kiểm toán. Hệ thống cần kiểm soát quyền truy cập, kiểm tra tài liệu trước khi tải xuống và tự động cảnh báo khi phát hiện sự cố.

## 3. Kiến trúc giải pháp

- **React và Flask** cung cấp giao diện và API.
- **Amazon Cognito** xác thực và phân quyền người dùng.
- **Amazon S3** lưu tài liệu ở chế độ private.
- **Amazon DynamoDB** lưu metadata và incident.
- **Amazon GuardDuty** quét mã độc và phát hiện hoạt động bất thường.
- **Amazon EventBridge và AWS Lambda** xử lý sự kiện bảo mật.
- **AWS Step Functions** hỗ trợ phê duyệt phản ứng sự cố.
- **Amazon SNS** gửi cảnh báo cho quản trị viên.
- **Amazon CloudWatch và Amazon Managed Grafana** giám sát hệ thống.
- **Amazon CloudFront và AWS WAF** bảo vệ và phân phối ứng dụng.

## 4. Mục tiêu kỹ thuật

- Bảo vệ tài liệu bằng S3 private và IAM theo nguyên tắc đặc quyền tối thiểu.
- Xác thực và phân quyền người dùng, quản trị viên.
- Quét mã độc trước khi cho phép tải xuống.
- Hỗ trợ quản lý phiên bản, xóa mềm và khôi phục tài liệu.
- Tự động ghi nhận, cảnh báo và xử lý sự cố.
- Yêu cầu phê duyệt trước khi cách ly hoặc dừng EC2.
- Theo dõi log và metric bằng CloudWatch.

## 5. Kế hoạch triển khai

- **Giai đoạn 1:** Phân tích yêu cầu và thiết kế kiến trúc.
- **Giai đoạn 2:** Xây dựng frontend, backend và hạ tầng AWS.
- **Giai đoạn 3:** Triển khai S3, DynamoDB, Cognito và chức năng quản lý tài liệu.
- **Giai đoạn 4:** Tích hợp GuardDuty, Lambda, SNS và Step Functions.
- **Giai đoạn 5:** Kiểm thử, giám sát, tối ưu và tài liệu hóa.

## 6. Rủi ro và biện pháp giảm thiểu

- **Truy cập trái phép:** Sử dụng Cognito, IAM và S3 private.
- **Tệp nhiễm mã độc:** Chỉ cho phép tải xuống sau khi tệp được quét an toàn.
- **Xóa nhầm dữ liệu:** Bật S3 Versioning và hỗ trợ khôi phục.
- **Phản ứng sai tài nguyên:** Áp dụng allowlist và phê duyệt thủ công.
- **Phát sinh chi phí:** Theo dõi tài nguyên và dọn dẹp sau thử nghiệm.

## 7. Kết quả kỳ vọng

Hệ thống cung cấp quy trình quản lý tài liệu an toàn từ tải lên, quét mã độc, lưu trữ đến tải xuống. Đồng thời, hệ thống có thể phát hiện, cảnh báo, lưu vết và phản ứng với sự cố bảo mật theo quy trình có kiểm soát.
