---
title: "Workshop Overview"
date: 2026-07-20
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

# Workshop Overview

## Problem statement

Internal documents may contain business, personal, or sensitive information. Storing files on a conventional server creates risks such as data loss, unauthorized access, malware downloads, missing version history, and insufficient audit evidence.

Document Security addresses these risks with layered security:

- The document and frontend buckets remain private.
- The browser never receives AWS access keys.
- File type and the 20 MB limit are validated at both frontend and backend.
- New files remain in quarantine/ and can only be downloaded after reaching CLEAN status.
- S3 Versioning, Recycle bin, and an audit table protect the document lifecycle.
- GuardDuty findings create incidents; EC2 isolation or stopping requires approval.
- Logs, metrics, and action history are centralized for investigation and audit.

## Learning outcomes

You will learn to distribute a private SPA through CloudFront OAC; authenticate with Cognito; upload, scan, version, delete, and recover documents; convert GuardDuty events into incidents; implement human approval with Step Functions, SNS, and API Gateway; safely respond to EC2 incidents; and monitor the system using CloudWatch and Grafana.

## Overall architecture

![Overall architecture of the Document Security system on AWS](/5-workshop/document-security/img-01-architecture.png)

Users access the application through AWS WAF and Amazon CloudFront. Amazon S3 serves the frontend, Amazon Cognito provides authentication, and Amazon EC2 runs the backend. Documents are stored in Amazon S3, while metadata and incidents are stored in Amazon DynamoDB.

CloudTrail, AWS Config, and CloudWatch provide logs and events. GuardDuty, Security Hub, and EventBridge detect, aggregate, and route incidents. Step Functions, API Gateway, and Lambda orchestrate response workflows; SNS sends alerts, and Systems Manager provides secure operational access.
