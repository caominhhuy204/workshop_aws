---
title: "Authentication and Document Lifecycle"
date: 2026-07-20
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

# Authentication and Document Lifecycle

## Authentication and authorization

The backend supports AUTH_PROVIDER=demo for local testing and AUTH_PROVIDER=cognito on AWS. The frontend sends the access token as follows:

Users enter their assigned credentials on the **Sign in** page. Passwords must remain masked and must never appear in logs or screenshots.

![Document Security application sign-in screen](/5-workshop/document-security/img-07-login.png)

```http
Authorization: Bearer <token>
```

The backend validates tokens and roles on every sensitive API. Users can view, upload, and download clean files. Only Admins can delete, recover, manage versions, and execute incident actions.

### Admin group

The admin group is for administrators with full document-management and incident-response permissions. Its members must be **Confirmed** and **Enabled**.

![Members of the admin group in Amazon Cognito](/5-workshop/document-security/img-07-cognito-admin-group.png)

### User group

The user group is for standard users with document read and upload permissions. Administrative APIs must still enforce the role at the backend.

![Members of the user group in Amazon Cognito](/5-workshop/document-security/img-07-cognito-user-group.png)

## Upload and scan workflow

1. The user selects a file on the Upload page.
2. The frontend validates the extension and 20 MB limit.
3. The backend validates again, sanitizes the name, and creates a UUID.
4. The file is uploaded to quarantine/; metadata starts as PENDING_SCAN.
5. GuardDuty Malware Protection scans the object.
6. EventBridge invokes the result-processing Lambda.
7. A clean file is released to clean/, marked CLEAN, and enabled for download.
8. An infected file remains quarantined, is marked INFECTED, has download disabled, creates an incident, and triggers SNS.

Allowed extensions: pdf, doc, docx, xls, xlsx, png, jpg, jpeg, and txt.

The Upload page displays the file name, size, allowed formats, and transfer progress. In the following example, a valid 114.8 KB JPEG file has reached 100% upload progress.

![Upload Document page with a valid file and progress indicator](/5-workshop/document-security/img-08-upload-progress.png)

New files are placed in the quarantine/ prefix so GuardDuty Malware Protection can inspect them before downloads are allowed.

![Objects isolated in the S3 quarantine prefix](/5-workshop/document-security/img-09-s3-quarantine-prefix.png)

After GuardDuty confirms that a file is safe, the system releases the object to the clean/ prefix. The following list shows clean objects ready for the download workflow.

![Scanned clean objects in the S3 clean prefix](/5-workshop/document-security/img-09-s3-clean-prefix.png)

## Document dashboard

The dashboard summarizes document count, stored data, high-risk incidents, and S3/DynamoDB health. Users can search by file name or owner, filter by file type, and use Versions, Download, or Delete actions according to their role.

![Document management dashboard with metrics, health status, and file inventory](/5-workshop/document-security/img-10-document-dashboard.png)

## Secure downloads

The backend generates a short-lived presigned URL only for scanstatus=CLEAN. PENDING_SCAN, INFECTED, SCAN_FAILED, and UNSCANNED return HTTP 423 Locked.

In the interface, a document marked **Clean** can be downloaded. A **Scan failed** document is not considered safe, so its Download button is disabled. This implements fail-closed behavior.

![Download comparison between Clean and Scan failed documents](/5-workshop/document-security/img-11-download-clean-scan-failed.png)

## Versioning, Recycle bin, and audit

- New versions must match the existing file type and pass scanning from a staging key.
- An infected replacement never supersedes the previous clean version.
- Soft delete creates an S3 Delete Marker, marks metadata DELETED, and moves the item to Recycle bin.
- Recover removes the latest Delete Marker and returns the document to ACTIVE.
- Restoring an older version creates a new version marked UNSCANNED until verified.
- Permanent deletion requires the exact phrase PERMANENTLY DELETE, a reason, and an audit record.
- Audit events include creation, version upload, scan result, soft delete, recover, restore, and permanent deletion.

The **Document versions** dialog displays object versions and Delete Markers. A Previous version can still be downloaded or restored, while the 0 B Deleted entry represents the Delete Marker created by soft deletion.

![Document versions and an S3 Delete Marker](/5-workshop/document-security/img-12-document-versions.png)

When an Admin selects Delete, the system displays a confirmation dialog explaining that the document moves to Recycle bin while its S3 versions and DynamoDB metadata remain available.

![Soft-delete confirmation dialog](/5-workshop/document-security/img-13-soft-delete-confirmation.png)

In Recycle bin, an Admin can review deleted documents and their malware status, then use **Recover** to return a document to the active inventory.

![Recycle bin with deleted documents and Recover actions](/5-workshop/document-security/img-13-recycle-bin.png)

The **Load audit history** action displays a chronological record. The following example captures document creation, a soft-delete request, and completion of the soft delete, including the actor and associated version ID for traceability.

![Document audit history with creation and soft-delete events](/5-workshop/document-security/img-14-document-audit-history.png)

{{% notice tip %}}
Test both User and Admin roles. Hiding frontend controls does not replace backend authorization.
{{% /notice %}}
