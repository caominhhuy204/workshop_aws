---
title: "Security Detection and Response"
date: 2026-07-20
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

# Security Detection and Incident Response

## Malware scan results

EventBridge receives **GuardDuty Malware Protection Object Scan Result** events. The Lambda verifies the bucket and prefix before processing.

Before testing uploads, confirm that the document bucket appears under **GuardDuty → Malware Protection for S3 → Protected buckets** with **Active** status and the expected protected prefix.

![GuardDuty Malware Protection for S3 protecting the document bucket](/5-workshop/document-security/img-15-guardduty-malware-protection.png)

- NO_THREATS_FOUND: release the object, set CLEAN, enable download, record audit, and delete the exact staging version.
- THREATS_FOUND: set INFECTED, disable download, store the threat name, create an incident, publish SNS, and retain quarantine.
- Failed or unknown result: set SCAN_FAILED, store the reason, and keep downloads locked using fail-closed behavior.

During testing, clean-scan-test-2.txt is marked **Clean** and can be downloaded. The eicar.com.txt test file is marked **Infected**, so its Download action is disabled and the file remains quarantined.

![Scan results for a clean file and an infected EICAR test file](/5-workshop/document-security/img-16-clean-eicar-results.png)

When a malicious object is detected, the Lambda creates an Object:S3/MaliciousFile incident. The incident records HIGH severity, OPEN status, the affected S3 resource, and malware information for administrator investigation.

![High-severity Object S3 MaliciousFile incidents](/5-workshop/document-security/img-17-malware-incidents.png)

## GuardDuty finding and approval flow

1. GuardDuty emits a finding and EventBridge routes it.
2. Step Functions invokes SecurityIncidentResponse.
3. Lambda normalizes severity, records the incident, and publishes SNS.
4. Eligible EC2 findings enter an approval wait state.
5. The approver selects QUARANTINE, STOP, or REJECT.
6. A response Lambda acts only after a valid callback.

The **Incidents** page refreshes automatically and centralizes S3, IAM, and EC2 incidents. Administrators can filter by severity, status, or finding type, then select an incident to inspect its AWS context and available actions.

![Incident stream containing S3 IAM and EC2 findings](/5-workshop/document-security/img-18-incident-stream.png)

Selecting an EC2 incident displays its finding type, severity, status, Region, and affected instance. An Admin can request quarantine, restore the original Security Groups, stop EC2 in an emergency, or update the investigation status.

![EC2 incident detail and Admin response actions](/5-workshop/document-security/img-18-incident-detail-actions.png)

Step Functions uses waitForTaskToken with an 86,400-second timeout. Approval Callback exposes ANY /approval. GET displays confirmation without changing resources; POST calls SendTaskSuccess. Expired, missing, or reused tokens return HTTP 409.

The state machine first processes the GuardDuty finding, determines whether approval is required, and moves the execution to WaitForSecurityApproval. After receiving a callback, RouteDecision selects Quarantine, Stop, Reject, or the no-approval completion path.

![Step Functions graph orchestrating incident response and approval](/5-workshop/document-security/img-20-step-functions-graph.png)

## Response actions and safeguards

- **Quarantine:** save original Security Groups, replace the primary ENI group with the quarantine group, and set the incident to INVESTIGATING.
- **Restore:** restore original groups, tag the instance, and set the incident to RESOLVED.
- **Stop:** call StopInstances only after approval and record the approver and time.

Only Admins may invoke response APIs. The instance must be allowed and not protected; the quarantine group must belong to the same VPC; original groups must be saved; and every action must update DynamoDB, audit, and notifications.

{{% notice warning %}}
Do not automatically isolate or stop production EC2 instances based solely on a finding. Retain human approval and assess the blast radius.
{{% /notice %}}
