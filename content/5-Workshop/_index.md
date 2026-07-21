---
title: "Workshop"
date: 2026-07-20
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Building a Secure Document Management and Human-Approved Incident Response System on AWS

#### Overview

This workshop builds **Document Security** in **Asia Pacific (Singapore) – ap-southeast-1**. The system manages the complete document lifecycle, scans files before download, and orchestrates security response with human approval.

The architecture uses React, CloudFront, and S3 for the frontend; Flask on EC2 for the backend; private S3 and DynamoDB for data; Cognito for authentication; GuardDuty, Security Hub, EventBridge, Lambda, and Step Functions for detection and response; and CloudWatch with Grafana for observability.

#### Access the project

{{% button href="https://d3rxc4d21dw065.cloudfront.net/login" icon="fas fa-external-link-alt" %}}Open Document Security{{% /button %}}

**Direct URL:** [https://d3rxc4d21dw065.cloudfront.net/login](https://d3rxc4d21dw065.cloudfront.net/login)

#### Demo accounts

| Role | Username | Password |
|---|---|---|
| Admin | minhtri | Minhtri@123 |
| User | thanhnam | Thanhnam@123 |

{{% notice warning %}}
These are shared demo accounts. Do not upload real or sensitive documents, and do not change another user's password or account information.
{{% /notice %}}

#### Content

1. [Workshop Overview](5.1-Workshop-overview/)
2. [Architecture and Preparation](5.2-Prerequiste/)
3. [Authentication and Document Lifecycle](5.3-S3-vpc/)
4. [Security Detection and Response](5.4-S3-onprem/)
5. [Application Deployment and Delivery](5.5-Policy/)
6. [Monitoring, Testing, and Assessment](5.6-Cleanup/)
7. [Operations, Troubleshooting, and Cleanup](5.7-Operations/)

{{% notice warning %}}
This workshop creates resources that may incur costs. Use a lab account and never expose access keys, secrets, email addresses, or task tokens in source code or screenshots.
{{% /notice %}}
