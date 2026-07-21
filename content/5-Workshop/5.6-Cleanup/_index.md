---
title: "Monitoring and Testing"
date: 2026-07-20
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

# Monitoring, Testing, and Security Assessment

## CloudWatch and Grafana

Collect Nginx, system, and Lambda logs. Monitor EC2, Lambda, DynamoDB, S3, EventBridge, SNS, Step Functions, and CloudFront metrics. Configure the Grafana CloudWatch data source for ap-southeast-1 with a read-only IAM role.

The DocumentApp-Monitoring dashboard displays key operational metrics for the backend EC2 instance. Memory and Disk are custom metrics published by CloudWatch Agent, while CPUUtilization is a standard EC2 metric.

![CloudWatch dashboard monitoring backend Memory Disk and CPU](/5-workshop/document-security/img-27-cloudwatch-dashboard.png)

Log Management centralizes the four Lambda log groups, VPC Flow Logs, Nginx access/error logs, and system logs. The lab retains infrastructure logs for one or two weeks to control cost; for longer-running environments, configure an appropriate retention period for Lambda logs rather than retaining them indefinitely.

![CloudWatch Log groups used by the system](/5-workshop/document-security/img-27-cloudwatch-log-groups.png)

Access Grafana using SSM port forwarding instead of exposing TCP 3000:

```bash
aws ssm start-session \
  --target <ec2-instance-id> \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["3000"],"localPortNumber":["3000"]}'
```

Open http://localhost:3000.

The **Document App - AWS Services Monitoring** dashboard combines Lambda invocations, errors, duration, and throttles; DynamoDB reads, writes, and system errors; and S3/SNS metrics in one operational view.

![Document App AWS Services Monitoring in Grafana](/5-workshop/document-security/img-28-grafana-aws-services.png)

The **Document App - Security Logs Monitoring** dashboard centralizes HTTP requests, 4xx/5xx responses, Lambda log events, Security Incident Response logs, and Nginx access logs for investigation.

![Document App Security Logs Monitoring in Grafana](/5-workshop/document-security/img-28-grafana-security-logs.png)

## Audit evidence

| Source | Evidence |
|---|---|
| CloudTrail | Management API history |
| VPC Flow Logs | ENI network ACCEPT/REJECT |
| S3 Server Access Logging | Bucket access requests |
| AWS Config | Configuration changes and compliance |
| DocumentVersionAudit | Per-document and version actions |
| SecurityIncidents | Findings, status, and response actions |

## Required tests

| Area | Test | Expected result |
|---|---|---|
| Auth | Invalid password; User calls Admin API | HTTP 401/403 |
| Upload | Valid, unsupported, and over 20 MB files | Pending scan or HTTP 400 |
| Malware | Clean file and EICAR | Clean enables download; Infected creates incident |
| Download | File not clean | HTTP 423 |
| Version | Clean/infected replacement and restore | Infected version never replaces clean version |
| Delete | Soft delete, recover, permanent delete | Correct marker/audit and confirmation |
| Incident | GuardDuty sample finding | Incident and SNS notification |
| Approval | Quarantine, restore, stop, reused link | Correct action; reused link returns 409 |
| Health | Origin and CloudFront | All dependencies OK |
| SPA | Refresh /login or /incidents | No 404 |

Acceptance requires private buckets, clean-only downloads, enforced Admin APIs, correct version/recycle/audit behavior, constrained EC2 response, fresh CloudWatch/Grafana data, and stable CloudFront SPA/API delivery.

For production, add a custom domain and ACM, HTTPS origin, Secrets Manager or Parameter Store, MFA, backup/PITR, lifecycle policies, WAF blocking rules, and a multi-Region disaster recovery strategy.
