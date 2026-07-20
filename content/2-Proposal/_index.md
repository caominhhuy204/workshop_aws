---
title: "Project Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Secure Document Management System on AWS

## 1. Overview

This project builds a document management system on AWS that allows users to securely sign in, upload, search for, and download documents. The system supports malware scanning, version management, activity monitoring, and security incident response.

## 2. Problem Statement

Internal documents are at risk of unauthorized access, malware infection, accidental deletion, and insufficient audit history. The system must control access, verify that documents are safe before download, and automatically alert administrators when an incident is detected.

## 3. Solution Architecture

- **React and Flask** provide the user interface and API.
- **Amazon Cognito** authenticates users and manages authorization.
- **Amazon S3** stores documents privately.
- **Amazon DynamoDB** stores metadata and incident records.
- **Amazon GuardDuty** scans files for malware and detects abnormal activity.
- **Amazon EventBridge and AWS Lambda** process security events.
- **AWS Step Functions** supports approval-based incident response.
- **Amazon SNS** sends alerts to administrators.
- **Amazon CloudWatch and Amazon Managed Grafana** monitor the system.
- **Amazon CloudFront and AWS WAF** protect and deliver the application.

## 4. Technical Objectives

- Protect documents using private S3 storage and least-privilege IAM permissions.
- Authenticate users and enforce user and administrator roles.
- Scan files for malware before permitting downloads.
- Support document versioning, soft deletion, and recovery.
- Automatically record, alert on, and respond to incidents.
- Require approval before quarantining resources or stopping EC2 instances.
- Monitor logs and metrics with CloudWatch.

## 5. Implementation Plan

- **Phase 1:** Analyze requirements and design the architecture.
- **Phase 2:** Build the frontend, backend, and AWS infrastructure.
- **Phase 3:** Deploy S3, DynamoDB, Cognito, and document management features.
- **Phase 4:** Integrate GuardDuty, Lambda, SNS, and Step Functions.
- **Phase 5:** Test, monitor, optimize, and document the system.

## 6. Risks and Mitigation

- **Unauthorized access:** Use Cognito, IAM, and private S3 storage.
- **Malware-infected files:** Permit downloads only after a successful security scan.
- **Accidental deletion:** Enable S3 Versioning and provide recovery capabilities.
- **Incorrect resource response:** Apply an allowlist and require manual approval.
- **Unexpected costs:** Monitor resources and clean them up after testing.

## 7. Expected Outcomes

The system provides a secure document management workflow covering upload, malware scanning, storage, and download. It can also detect, alert on, audit, and respond to security incidents through a controlled process.
