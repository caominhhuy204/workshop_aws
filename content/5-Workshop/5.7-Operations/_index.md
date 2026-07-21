---
title: "Operations and Cleanup"
date: 2026-07-20
weight: 7
chapter: false
pre: " <b> 5.7. </b> "
---

# Operations, Troubleshooting, and Cleanup

## Frontend update procedure

Build the source, upload dist/, set no-cache on index.html, create a CloudFront /* invalidation, wait for completion, and verify in a private browser window.

## Restart procedure

Start EC2 and wait for 2/2 checks; verify the origin IP and Security Group; check Nginx and the backend service; call /api/health directly and through CloudFront; then test login, Documents, Incidents, and logs.

## Troubleshooting

| Symptom | Check |
|---|---|
| CloudFront 504 on /api/ | EC2, origin, SG, Nginx, and direct health |
| SPA 403/404 on refresh | Custom error fallback to /index.html |
| Upload 413 | client_max_body_size 20M |
| File remains Pending | Malware Protection, EventBridge, and Lambda logs |
| Download 423 | scanstatus and scan event |
| Recycle recovery fails | Latest S3 Delete Marker and DynamoDB |
| Approval 409 | Token reused or workflow timed out |
| Quarantine fails | Allowlist, protected list, VPC, and SG |
| Grafana has no data | Region, IAM role, and time range |
| Old UI remains | CloudFront invalidation and browser cache |

## Cost monitoring

Use Cost Explorer with **Group by: Service** to analyze the contribution from EC2, VPC, Security Hub, AWS Config, S3, Secrets Manager, CloudWatch, and other services. The following view captures monthly costs before resource cleanup.

![AWS Cost Explorer grouped by service](/5-workshop/document-security/img-30-cost-explorer.png)

## Cleanup

{{% notice danger %}}
Back up required data and capture evidence before cleanup. S3 versions, DynamoDB records, and logs may be unrecoverable.
{{% /notice %}}

1. Disable EventBridge rules and stop waiting Step Functions executions.
2. Export required data and audit evidence.
3. Delete lab Lambda functions, API Gateway, SNS resources, and dedicated roles.
4. Disable and delete CloudFront when allowed.
5. Delete every S3 object version and Delete Marker before deleting buckets.
6. Remove unused DynamoDB tables, log groups, and alarms.
7. Terminate EC2 and verify EBS, EIP, ENI, and Security Group cleanup.
8. Disable GuardDuty/Security Hub only if the account no longer needs protection.

Finally, use Cost Explorer and Resource Explorer/Tag Editor to confirm no billable resources remain.
