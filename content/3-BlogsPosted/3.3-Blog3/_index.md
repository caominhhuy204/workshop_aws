---
title: "Blog 3"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---
{{% notice warning %}}
⚠️ **Note:** The information below is for reference purposes only. Please **do not copy verbatim** for your report, including this warning.
{{% /notice %}}

# Amazon EC2 Auto Scaling Group in AWS Architecture

## 1. Research Overview

While studying Amazon EC2 services, Amazon EC2 Auto Scaling Group stands out as an important component for building scalable and resilient systems. At first, Auto Scaling may seem like a service that simply creates more EC2 instances when traffic increases. However, after studying it more carefully, Auto Scaling Group is not only about increasing server count. It manages the lifecycle of EC2 instances within a group.

A website or application can run on a single EC2 instance when traffic is small. However, when traffic spikes or the server fails, relying on one instance becomes a risk to availability. Auto Scaling Group is designed to solve this by maintaining the desired number of instances, scaling out when load increases, and replacing unhealthy instances when needed.

![Architecture using Auto Scaling Group behind an Application Load Balancer](/images/blog3-auto-scaling-2.jpg)

## 2. Limitations of Using a Single EC2 Instance

A single EC2 instance may be enough for a personal website, demo system, or small internal application. However, for systems serving many users, a single instance can introduce several limitations:

* If the instance fails, the entire application may become unavailable.
* When traffic increases suddenly, the server may become overloaded.
* Manual scaling takes time and depends on operators.
* It is difficult to optimize cost when traffic changes over time.
* It does not meet high availability requirements for production environments.

For systems that require scalability and high availability, Auto Scaling Group becomes an important architecture component.

## 3. Auto Scaling Group Is More Than Adding EC2 Instances

A key lesson is that Auto Scaling Group does more than create additional servers. It manages the lifecycle of EC2 instances according to the configuration defined by the administrator.

| Function | Meaning |
| --- | --- |
| Scale out | Automatically increases EC2 instance count when load increases |
| Scale in | Automatically decreases EC2 instance count when load decreases |
| Health check | Checks the health status of instances |
| Self-healing | Replaces unhealthy instances with new ones |
| Desired capacity | Maintains the desired number of instances |
| Load Balancer integration | Routes requests to healthy instances |

These capabilities help the system operate more reliably without requiring continuous manual monitoring.

## 4. Self-Healing Capability

One of the most valuable capabilities of Auto Scaling Group is self-healing. For example, if a system is configured to run with 3 EC2 instances and one instance fails a health check, Auto Scaling Group can terminate that unhealthy instance and launch a new one to replace it.

This process helps maintain the required number of servers. When combined with an Application Load Balancer, user requests are routed only to healthy instances, reducing the impact of failures on user experience.

## 5. Role of Amazon CloudWatch

Auto Scaling Group does not guess when to scale. Scaling decisions are usually based on metrics collected and monitored by Amazon CloudWatch.

Common metrics used in scaling policies include:

* CPU Utilization exceeding a threshold such as 70%.
* High request volume.
* Increased network traffic.
* Higher load balancer target response time.
* Custom metrics published by the application to CloudWatch.

When a metric crosses the configured threshold, CloudWatch can trigger a scaling policy and Auto Scaling Group can launch additional EC2 instances. When load decreases, Auto Scaling Group can reduce instance count to save cost.

## 6. Integration with Application Load Balancer

In production architecture, Auto Scaling Group is commonly combined with Application Load Balancer. The Load Balancer receives user requests and distributes them across EC2 instances in the Auto Scaling Group.

This combination provides several benefits:

* Requests are distributed across multiple instances.
* Unhealthy instances can be removed from traffic routing.
* The system can scale without changing the endpoint accessed by users.
* Application deployment becomes more flexible.
* Availability and fault tolerance are improved.

## 7. When to Use Auto Scaling Group

Auto Scaling Group is useful, but not every system needs it at the beginning. For a personal website, internal website, demo system, or small project, one EC2 instance may already be sufficient.

Using Auto Scaling Group in a small system can increase complexity because it requires configuring Launch Template, Load Balancer, Security Group, scaling policy, and health checks. Cost may also increase if the minimum instance count is higher than actual demand.

Auto Scaling Group should be considered when the system has the following requirements:

* Traffic changes over time.
* High availability is required.
* The system should not depend on a single server.
* Unhealthy instances should be replaced automatically.
* Cost should be optimized by scaling resources based on real load.

## 8. Lessons Learned

After studying Auto Scaling Group, it becomes clear that building a cloud system is not just about launching one EC2 instance and running an application. The more important goal is to design a system that can scale when users increase and recover when resources fail.

Auto Scaling Group reflects the AWS design mindset: a system should not only run, but also stay ready for real-world changes. When combined with CloudWatch and Application Load Balancer, Auto Scaling Group improves reliability, reduces operational effort, and increases scalability.

## 9. Conclusion

Amazon EC2 Auto Scaling Group is not simply a service that creates more EC2 instances. It helps systems scale automatically based on demand, improve availability, recover from instance failures, and optimize cost as traffic changes.

For real-world AWS applications, especially production systems or systems with variable user traffic, Auto Scaling Group is an important service to understand and apply properly.


**Reference:** <https://aws.amazon.com/blogs/compute/introducing-instance-refresh-for-ec2-auto-scaling/>
