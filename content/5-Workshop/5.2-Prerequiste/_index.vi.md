---
title: "Kiến trúc và chuẩn bị"
date: 2026-07-20
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

# Kiến trúc và chuẩn bị

## Thành phần kiến trúc

| Thành phần | Vai trò |
|---|---|
| CloudFront + AWS WAF | Điểm truy cập cho SPA và /api/, cache tại edge và bảo vệ request |
| S3 Frontend + OAC | Lưu bản build React private; chỉ CloudFront được đọc |
| EC2 + Nginx + Gunicorn/Flask | Reverse proxy và xử lý API nghiệp vụ |
| S3 Documents | Lưu tài liệu private, bật Versioning và mã hóa |
| DynamoDB | Lưu metadata, audit phiên bản và incident |
| Cognito | Xác thực người dùng và ánh xạ group admin |
| GuardDuty + Security Hub | Quét malware và tổng hợp findings |
| EventBridge + Lambda | Định tuyến và xử lý sự kiện |
| Step Functions + SNS + API Gateway | Chờ và nhận quyết định phê duyệt |
| CloudWatch + Grafana | Log, metric, alarm và dashboard |
| Systems Manager | Quản trị EC2 và truy cập Grafana không mở cổng public |

## Điều kiện tiên quyết

- AWS account có quyền tạo các dịch vụ trong Workshop.
- AWS CLI v2, Node.js 18+, npm, Python 3.10+, Git và Session Manager plugin.
- Region mặc định: ap-southeast-1.
- Mã nguồn frontend, backend, Lambda và dashboard Grafana của dự án.

Kiểm tra tài khoản và Region:

```bash
aws sts get-caller-identity
aws configure get region
```

## Nguyên tắc IAM

- Không cấp AWS credential cho frontend.
- EC2 dùng instance profile và chỉ được truy cập bucket, bảng, Lambda, Cognito và log group cần thiết.
- Lambda malware chỉ xử lý object đúng bucket/prefix và các bảng liên quan.
- Lambda phản ứng chỉ tác động instance trong ALLOWED_INSTANCE_IDS.
- Instance quan trọng phải nằm trong PROTECTED_INSTANCE_IDS.
- Grafana chỉ có quyền đọc CloudWatch.
- Callback chỉ chấp nhận quyết định hợp lệ và task token còn hiệu lực.

### IAM Role của backend EC2

EC2 backend sử dụng IAM Role thay vì access key dài hạn. Role này được gắn các policy phục vụ Systems Manager, CloudWatch Agent, đọc metric, xác thực Cognito, quản lý tài liệu/phiên bản và gọi Lambda phản ứng sự cố.

![Danh sách policy được gắn với IAM Role của EC2 backend](/5-workshop/document-security/img-02-iam-role-policies.png)

### Các Lambda của hệ thống

Hệ thống sử dụng bốn Lambda chính để xử lý kết quả quét malware, gửi yêu cầu phê duyệt, nhận callback và thực hiện phản ứng sự cố.

![Danh sách các AWS Lambda của hệ thống Document Security](/5-workshop/document-security/img-02-lambda-functions.png)

## Cấu hình lớp dữ liệu

Bucket tài liệu cần bật **Block Public Access**, **Versioning** và **Default encryption**. Dùng quarantine/ cho file mới và clean/ cho file đã được phát hành.

### Bật S3 Versioning

S3 Versioning đang ở trạng thái **Enabled**, cho phép giữ nhiều phiên bản của cùng một object và hỗ trợ khôi phục khi người dùng xóa hoặc ghi đè nhầm.

![Bucket Versioning được bật trên bucket tài liệu](/5-workshop/document-security/img-03-s3-versioning.png)

### Cấu hình mã hóa mặc định

Bucket sử dụng server-side encryption với Amazon S3 managed keys (SSE-S3). Mọi object mới được S3 mã hóa tự động khi lưu trữ.

![Default encryption SSE-S3 của bucket tài liệu](/5-workshop/document-security/img-03-s3-default-encryption.png)

### Chặn truy cập công khai

Thiết lập **Block all public access** phải ở trạng thái **On** để ngăn bucket hoặc object bị công khai ngoài ý muốn.

![Block all public access được bật trên bucket tài liệu](/5-workshop/document-security/img-04-s3-block-public-access.png)

```bash
aws s3api get-public-access-block --bucket <document-bucket>
aws s3api get-bucket-versioning --bucket <document-bucket>
aws s3api get-bucket-encryption --bucket <document-bucket>
```

Tạo ba bảng DynamoDB ở chế độ On-demand:

| Bảng | Partition key | Sort key | Mục đích |
|---|---|---|---|
| Documents | documentid | — | Metadata và trạng thái hiện tại |
| SecurityIncidents | incidentid | — | Finding và hành động phản ứng |
| DocumentVersionAudit | documentid | eventid | Lịch sử thao tác theo phiên bản |

Ba bảng được triển khai ở chế độ **On-demand** và phải có trạng thái **Active** trước khi backend bắt đầu đọc hoặc ghi dữ liệu.

![Ba bảng DynamoDB của hệ thống ở trạng thái Active](/5-workshop/document-security/img-05-dynamodb-tables.png)

Sau khi người dùng upload tài liệu, bảng Documents lưu metadata và trạng thái xử lý của từng tài liệu. Có thể kiểm tra dữ liệu tại **DynamoDB → Explore items → Documents**.

![Các item metadata trong bảng DynamoDB Documents](/5-workshop/document-security/img-06-dynamodb-documents-items.png)

## Biến môi trường backend

```env
AUTH_PROVIDER=cognito
CORS_ALLOWED_ORIGINS=https://<cloudfront-domain>
AWS_REGION=ap-southeast-1
S3_BUCKET_NAME=<document-bucket>
S3_QUARANTINE_PREFIX=quarantine
DYNAMODB_DOCUMENTS_TABLE=Documents
DYNAMODB_INCIDENTS_TABLE=SecurityIncidents
DYNAMODB_VERSION_AUDIT_TABLE=DocumentVersionAudit
SECURITY_RESPONSE_LAMBDA_FUNCTION=SecurityIncidentResponse
JWT_SECRET_KEY=<long-random-secret>
COGNITO_USER_POOL_ID=<user-pool-id>
COGNITO_CLIENT_ID=<app-client-id>
COGNITO_ADMIN_GROUP=admin
```

{{% notice warning %}}
Không commit .env. Không ghi account ID, ARN, email, secret hoặc ID tài nguyên thật vào bản Workshop công khai.
{{% /notice %}}
