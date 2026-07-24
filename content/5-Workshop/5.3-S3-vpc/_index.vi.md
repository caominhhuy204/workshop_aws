---
title: "Xác thực và vòng đời tài liệu"
date: 2026-07-20
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

# Xác thực và quản lý vòng đời tài liệu

## Xác thực và phân quyền

Backend hỗ trợ `AUTH_PROVIDER=demo` để kiểm thử cục bộ và `AUTH_PROVIDER=cognito` cho môi trường AWS. Sau đăng nhập, frontend gửi access token trong header:

Người dùng nhập tài khoản được cấp trên trang **Sign in**. Mật khẩu phải luôn được che và không xuất hiện trong log hoặc ảnh chụp.

![Màn hình đăng nhập của ứng dụng Document Security](/5-workshop/document-security/img-07-login.png)

```http
Authorization: Bearer <token>
```

Backend phải xác minh token và role cho mọi API nhạy cảm. User có thể xem, upload và download file sạch; chỉ Admin được xóa, khôi phục, quản lý phiên bản và thực hiện hành động với incident.

### Nhóm Admin

Group `admin` dành cho quản trị viên có đầy đủ quyền quản lý tài liệu và phản ứng sự cố. Các thành viên phải có trạng thái **Confirmed** và **Enabled**.

![Thành viên thuộc group admin trong Amazon Cognito](/5-workshop/document-security/img-07-cognito-admin-group.png)

### Nhóm User

Group `user` dành cho người dùng thông thường, chủ yếu có quyền đọc và upload tài liệu. Các API quản trị vẫn phải kiểm tra role tại backend.

![Thành viên thuộc group user trong Amazon Cognito](/5-workshop/document-security/img-07-cognito-user-group.png)

## Upload và quét tài liệu

1. Người dùng chọn file tại trang Upload.
2. Frontend kiểm tra phần mở rộng và kích thước tối đa 20 MB.
3. Backend kiểm tra lại, chuẩn hóa tên file và tạo UUID.
4. File được tải vào `quarantine/`; metadata được ghi với `PENDING_SCAN`.
5. GuardDuty Malware Protection quét object.
6. EventBridge gọi Lambda xử lý kết quả.
7. File sạch được phát hành vào `clean/`, đổi trạng thái `CLEAN` và mở download.
8. File nhiễm vẫn bị cách ly, chuyển `INFECTED`, khóa download, tạo incident và gửi SNS.

Loại file cho phép: `pdf`, `doc`, `docx`, `xls`, `xlsx`, `png`, `jpg`, `jpeg`, `txt`.

Trang Upload hiển thị tên, dung lượng, danh sách định dạng được phép và tiến trình truyền file. Trong ví dụ dưới đây, file JPEG dung lượng 114,8 KB đã được truyền lên backend với tiến trình 100%.

![Trang Upload Document với file hợp lệ và thanh tiến trình](/5-workshop/document-security/img-08-upload-progress.png)

File mới được đặt trong prefix `quarantine/` để GuardDuty Malware Protection kiểm tra trước khi hệ thống cho phép tải xuống.

![Các object đang được cách ly trong prefix quarantine của S3](/5-workshop/document-security/img-09-s3-quarantine-prefix.png)

Sau khi GuardDuty xác nhận file an toàn, hệ thống phát hành object vào prefix `clean/`. Danh sách dưới đây thể hiện các object sạch đã sẵn sàng phục vụ quy trình download.

![Các object đã quét sạch trong prefix clean của S3](/5-workshop/document-security/img-09-s3-clean-prefix.png)

## Dashboard tài liệu

Dashboard tập trung các chỉ số về số lượng tài liệu, dung lượng lưu trữ, incident rủi ro cao và trạng thái kết nối tới S3/DynamoDB. Người dùng có thể tìm kiếm theo tên hoặc chủ sở hữu, lọc theo loại file và sử dụng các hành động Versions, Download hoặc Delete tùy theo quyền.

![Dashboard quản lý tài liệu với metric, health status và danh sách file](/5-workshop/document-security/img-10-document-dashboard.png)

## Download an toàn

Backend chỉ tạo presigned URL khi `scanstatus=CLEAN`. Các trạng thái `PENDING_SCAN`, `INFECTED`, `SCAN_FAILED` hoặc `UNSCANNED` phải trả HTTP `423 Locked`. URL có thời hạn ngắn và không làm bucket trở thành public.

Trong giao diện, tài liệu có trạng thái **Clean** được phép Download. Tài liệu **Scan failed** không được xem là an toàn nên nút Download bị vô hiệu hóa. Cách xử lý này bảo đảm hệ thống hoạt động theo nguyên tắc fail closed.

![So sánh quyền Download giữa tài liệu Clean và Scan failed](/5-workshop/document-security/img-11-download-clean-scan-failed.png)

## Versioning và Recycle bin

- Phiên bản mới phải cùng loại với tài liệu hiện tại và được quét tại staging key.
- Phiên bản sạch cũ vẫn giữ nguyên nếu bản mới nhiễm mã độc.
- Xóa mềm tạo S3 Delete Marker, đổi metadata sang `DELETED` và đưa tài liệu vào Recycle bin.
- Recover xóa Delete Marker mới nhất và chuyển tài liệu về `ACTIVE`.
- Restore bản cũ tạo một version mới, đặt `UNSCANNED` và khóa download cho tới khi xác nhận an toàn.
- Permanent delete yêu cầu nhập chính xác `PERMANENTLY DELETE`, ghi lý do và audit vì không thể hoàn tác.

Cửa sổ **Document versions** hiển thị các object version và Delete Marker. Phiên bản `Previous` vẫn có thể được Download hoặc Restore, trong khi dòng `Deleted` 0 B đại diện cho Delete Marker được tạo khi xóa mềm.

![Danh sách phiên bản tài liệu và Delete Marker](/5-workshop/document-security/img-12-document-versions.png)

Khi Admin chọn Delete, hệ thống hiển thị hộp thoại xác nhận và giải thích rằng tài liệu sẽ được chuyển vào Recycle bin, trong khi S3 versions và DynamoDB metadata vẫn được giữ lại.

![Hộp thoại xác nhận xóa mềm tài liệu](/5-workshop/document-security/img-13-soft-delete-confirmation.png)

Trong Recycle bin, Admin có thể xem tài liệu đã xóa cùng trạng thái malware và sử dụng **Recover** để đưa tài liệu trở lại danh sách hoạt động.

![Recycle bin hiển thị tài liệu đã xóa và nút Recover](/5-workshop/document-security/img-13-recycle-bin.png)

## Audit history

Ghi tối thiểu các sự kiện: tạo tài liệu, yêu cầu upload version, kết quả scan, yêu cầu/xác nhận xóa mềm, recover, restore và xóa vĩnh viễn. Mỗi sự kiện cần có actor, timestamp, document/version ID, trạng thái và lý do nếu có.

Nút **Load audit history** hiển thị lịch sử theo thứ tự thời gian. Ví dụ dưới đây ghi nhận việc tạo tài liệu, yêu cầu xóa mềm và hoàn tất xóa mềm, kèm actor và version ID để phục vụ truy vết.

![Audit history của tài liệu với các sự kiện tạo và xóa mềm](/5-workshop/document-security/img-14-document-audit-history.png)

{{% notice tip %}}
Kiểm thử cả User và Admin. Việc ẩn nút trên frontend không thay thế kiểm tra quyền ở backend.
{{% /notice %}}
