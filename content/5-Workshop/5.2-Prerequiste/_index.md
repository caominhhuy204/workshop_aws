---
title: "Architecture and Preparation"
date: 2026-07-20
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

# Architecture and Preparation

## Architecture components

| Component | Responsibility |
|---|---|
| CloudFront + AWS WAF | Entry point for the SPA and /api/; edge caching and request protection |
| S3 Frontend + OAC | Private React build readable only by CloudFront |
| EC2 + Nginx + Gunicorn/Flask | Reverse proxy and business APIs |
| S3 Documents | Private, versioned, encrypted document storage |
| DynamoDB | Document metadata, version audit, and incidents |
| Cognito | User authentication and admin group mapping |
| GuardDuty + Security Hub | Malware scanning and security finding aggregation |
| EventBridge + Lambda | Event routing and processing |
| Step Functions + SNS + API Gateway | Approval wait state, notification, and callback |
| CloudWatch + Grafana | Logs, metrics, alarms, and dashboards |
| Systems Manager | EC2 administration and private Grafana access |

## Prerequisites

- An AWS account with permissions for all workshop services.
- AWS CLI v2, Node.js 18+, npm, Python 3.10+, Git, and the Session Manager plugin.
- Default Region ap-southeast-1.
- The project frontend, backend, Lambda, and Grafana source files.

```bash
aws sts get-caller-identity
aws configure get region
```

## IAM safety principles

Do not provide AWS credentials to the frontend. Use a least-privilege EC2 instance profile, restrict malware Lambda access by bucket/prefix, limit response actions through ALLOWED_INSTANCE_IDS, protect critical instances through PROTECTED_INSTANCE_IDS, and grant Grafana read-only CloudWatch access.

### Backend EC2 IAM Role

The backend EC2 instance uses an IAM Role instead of long-lived access keys. Its policies support Systems Manager, CloudWatch Agent, metric access, Cognito authentication, document/version management, and invocation of the incident-response Lambda.

![Policies attached to the backend EC2 IAM Role](/5-workshop/document-security/img-02-iam-role-policies.png)

### System Lambda functions

Four primary Lambda functions process malware scan results, send approval requests, receive approval callbacks, and perform incident-response actions.

![AWS Lambda functions used by the Document Security system](/5-workshop/document-security/img-02-lambda-functions.png)

## Data layer

Enable **Block Public Access**, **Versioning**, and **Default encryption** on the document bucket. Use quarantine/ for new files and clean/ for released files.

### Enable S3 Versioning

S3 Versioning is **Enabled**, preserving multiple versions of an object and supporting recovery from accidental deletion or overwrites.

![Bucket Versioning enabled on the document bucket](/5-workshop/document-security/img-03-s3-versioning.png)

### Configure default encryption

The bucket uses server-side encryption with Amazon S3 managed keys (SSE-S3). Amazon S3 automatically encrypts every new object at rest.

![SSE-S3 default encryption on the document bucket](/5-workshop/document-security/img-03-s3-default-encryption.png)

### Block public access

**Block all public access** must remain **On** to prevent the bucket or its objects from becoming publicly accessible unintentionally.

![Block all public access enabled on the document bucket](/5-workshop/document-security/img-04-s3-block-public-access.png)

```bash
aws s3api get-public-access-block --bucket <document-bucket>
aws s3api get-bucket-versioning --bucket <document-bucket>
aws s3api get-bucket-encryption --bucket <document-bucket>
```

Create three On-demand DynamoDB tables:

| Table | Partition key | Sort key | Purpose |
|---|---|---|---|
| Documents | documentid | — | Current metadata and status |
| SecurityIncidents | incidentid | — | Findings and response actions |
| DocumentVersionAudit | documentid | eventid | Per-version action history |

All three tables use **On-demand** capacity and must be **Active** before the backend starts reading or writing data.

![The three system DynamoDB tables in Active state](/5-workshop/document-security/img-05-dynamodb-tables.png)

After a user uploads a document, the Documents table stores its metadata and processing state. Review these records under **DynamoDB → Explore items → Documents**.

![Document metadata items in the DynamoDB Documents table](/5-workshop/document-security/img-06-dynamodb-documents-items.png)

## Backend environment

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
Never commit .env or expose real account IDs, ARNs, email addresses, secrets, or resource IDs in a public workshop.
{{% /notice %}}
