---
title: "Workshop"
date: 2026-07-20
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Xây dựng hệ thống quản lý tài liệu an toàn và phản ứng sự cố có phê duyệt trên AWS

#### Tổng quan

Workshop này hướng dẫn xây dựng **Document Security** tại Region **Asia Pacific (Singapore) – ap-southeast-1**. Hệ thống quản lý toàn bộ vòng đời tài liệu, quét mã độc trước khi cho tải xuống và điều phối phản ứng sự cố có bước phê duyệt của con người.

Kiến trúc sử dụng React, CloudFront và S3 cho giao diện; Flask chạy trên EC2 cho backend; S3 private và DynamoDB cho dữ liệu; Cognito cho xác thực; GuardDuty, Security Hub, EventBridge, Lambda và Step Functions cho phát hiện, phê duyệt và phản ứng; CloudWatch và Grafana cho giám sát.

#### Truy cập dự án

{{% button href="https://d3rxc4d21dw065.cloudfront.net/login" icon="fas fa-external-link-alt" %}}Mở ứng dụng Document Security{{% /button %}}

**Đường dẫn trực tiếp:** [https://d3rxc4d21dw065.cloudfront.net/login](https://d3rxc4d21dw065.cloudfront.net/login)

#### Tài khoản dùng thử

| Vai trò | Tên đăng nhập | Mật khẩu |
|---|---|---|
| Admin | minhtri | Minhtri@123 |
| User | thanhnam | Thanhnam@123 |

{{% notice warning %}}
Đây là tài khoản demo dùng chung. Không upload tài liệu thật hoặc dữ liệu nhạy cảm; không đổi mật khẩu hay thông tin tài khoản của người dùng khác.
{{% /notice %}}

#### Nội dung

1. [Tổng quan Workshop](5.1-Workshop-overview/)
2. [Kiến trúc và chuẩn bị](5.2-Prerequiste/)
3. [Xác thực và vòng đời tài liệu](5.3-S3-vpc/)
4. [Phát hiện và phản ứng sự cố](5.4-S3-onprem/)
5. [Triển khai và phân phối ứng dụng](5.5-Policy/)
6. [Giám sát, kiểm thử và đánh giá](5.6-Cleanup/)
7. [Vận hành, xử lý sự cố và dọn dẹp](5.7-Operations/)
8. [Video Demo](5.8-Demo/)

{{% notice warning %}}
Workshop tạo các tài nguyên có thể phát sinh chi phí. Hãy triển khai trong tài khoản lab, không đưa access key, secret, email hoặc task token thật vào source code hay ảnh chụp.
{{% /notice %}}
