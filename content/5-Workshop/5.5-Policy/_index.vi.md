---
title: "Triển khai ứng dụng"
date: 2026-07-20
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

# Triển khai và phân phối ứng dụng

## Frontend: React, S3 và CloudFront

Build frontend:

```bash
cd frontend
npm install
npm run build
```

Đồng bộ thư mục `dist/` lên bucket frontend private. Không dùng `--delete` khi chưa kiểm tra kỹ phạm vi.

Sau khi đồng bộ, thư mục gốc của bucket phải có `index.html`, thư mục `assets/` và các icon cần thiết. `index.html` là entry point của SPA và được cấu hình làm Default root object trên CloudFront.

![Thư mục gốc của S3 frontend với index.html và assets](/5-workshop/document-security/img-22-frontend-bucket-root.png)

Thư mục `assets/` chứa các bundle JavaScript và CSS được Vite tạo trong quá trình build. Tên file có hash giúp trình duyệt và CloudFront quản lý cache theo từng phiên bản triển khai.

![Các bundle JavaScript và CSS trong thư mục assets của S3 frontend](/5-workshop/document-security/img-22-frontend-assets.png)

```bash
aws s3 sync ./dist s3://<frontend-bucket>
aws s3 cp ./dist/index.html s3://<frontend-bucket>/index.html \
  --content-type "text/html" \
  --cache-control "no-cache, no-store, must-revalidate"
```

Cấu hình CloudFront:

| Thiết lập | Giá trị |
|---|---|
| Default root object | `index.html` |
| Default behavior | S3 private qua OAC |
| `/api/*` behavior | EC2/Nginx origin, cache disabled |
| Viewer protocol | Redirect HTTP to HTTPS |
| SPA fallback | 403/404 trả `/index.html` với HTTP 200 |

Distribution sử dụng hai origin: S3 cho frontend và `SecurityPortalBackend` cho API chạy trên EC2.

![Hai CloudFront origins dành cho S3 frontend và EC2 backend](/5-workshop/document-security/img-23-cloudfront-origins.png)

Behavior `/api/*` định tuyến request đến backend, tắt cache và chuyển đầy đủ thông tin viewer cần thiết. Default behavior phân phối frontend từ S3 với cache tối ưu. Cả hai đều chuyển HTTP sang HTTPS.

![CloudFront behaviors cho API backend và S3 frontend](/5-workshop/document-security/img-23-cloudfront-behaviors.png)

Sau mỗi lần deploy, tạo invalidation:

```bash
aws cloudfront create-invalidation \
  --distribution-id <distribution-id> \
  --paths "/*"
```

Sau khi distribution triển khai hoàn tất, truy cập CloudFront domain bằng HTTPS và kiểm tra route `/login`. Giao diện phải tải đầy đủ bundle, icon và form đăng nhập mà không truy cập trực tiếp bucket S3.

![Website Document Security được phân phối qua CloudFront](/5-workshop/document-security/img-24-cloudfront-website.png)

## Truy cập ứng dụng

{{% button href="https://d3rxc4d21dw065.cloudfront.net/login" icon="fas fa-external-link-alt" %}}Truy cập Document Security{{% /button %}}

**URL:** [https://d3rxc4d21dw065.cloudfront.net/login](https://d3rxc4d21dw065.cloudfront.net/login)

### Tài khoản dùng thử

| Vai trò | Tên đăng nhập | Mật khẩu | Quyền chính |
|---|---|---|---|
| Admin | `minhtri` | `Minhtri@123` | Quản lý tài liệu, phiên bản, Recycle bin và incident |
| User | `thanhnam` | `Thanhnam@123` | Xem, upload và download tài liệu sạch |

{{% notice warning %}}
Chỉ sử dụng dữ liệu thử nghiệm. Không upload tài liệu cá nhân, thông tin bí mật hoặc nội dung nhạy cảm lên hệ thống demo.
{{% /notice %}}

## Backend: EC2, Nginx và Gunicorn

Luồng request:

```text
CloudFront /api/* -> Nginx :80 -> Gunicorn/Flask :5000
```

Trước khi triển khai backend, xác nhận EC2 ở trạng thái **Running** và tất cả status checks đều passed. Môi trường lab sử dụng instance `t3.micro` trong Availability Zone `ap-southeast-1a`.

![Backend EC2 đang Running với status checks passed](/5-workshop/document-security/img-25-ec2-running.png)

Cài dependency trong virtual environment và chạy Gunicorn bằng `systemd`, đặt `Restart=always`. Service đọc biến môi trường từ file chỉ root/service account có quyền truy cập.

```bash
cd /app/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Cấu hình Nginx mẫu:

```nginx
location /api/ {
    proxy_pass http://127.0.0.1:5000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    client_max_body_size 20M;
}
```

## Kiểm tra health

```bash
curl -i http://<backend-origin>/api/health
curl -i https://<cloudfront-domain>/api/health
```

Kết quả cần thể hiện backend, S3 và ba bảng DynamoDB đều `ok: true`. Nếu một dependency lỗi, trạng thái tổng phải là `degraded`.

Kết quả dưới đây xác nhận endpoint `/api/health` hoạt động qua CloudFront. Backend, S3, bảng Documents, SecurityIncidents và DocumentVersionAudit đều trả `ok: true`.

![Kết quả API health check qua CloudFront](/5-workshop/document-security/img-26-cloudfront-health-check.png)

{{% notice info %}}
Trong production, nên đặt backend sau Application Load Balancer, dùng HTTPS đến origin và cân nhắc Auto Scaling Group.
{{% /notice %}}
