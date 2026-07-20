---
title: "Event 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 4.2. </b> "
---

{{% notice warning %}}
⚠️ **Note:** The information below is for reference purposes only. Please **do not copy it verbatim** into your report, including this warning.
{{% /notice %}}

# Summary Report: AI Career Direction, CloudFront, and Multi-Agent Systems

## 1. Event Information

**Date:** 23/05/2026  
**Participation role:** Attendee  
**Main topics:** Career direction in the AI era, Prompt Engineering, Multi-Agent Systems, Amazon CloudFront, security, and Hackathon experience.

The event focused on how IT engineers can adapt to the rapid growth of AI and how AI can be applied in enterprise environments. The topics covered AI tools, security, cloud infrastructure, multi-agent architecture, and product-building mindset.

## 2. Event Objectives

The event helped participants better understand changes in the technology industry as AI continues to grow. The main objectives included:

* Providing career direction and development strategy for IT engineers in the AI era.
* Sharing best practices for Prompt Engineering and context design.
* Introducing enterprise-level Multi-Agent architecture.
* Updating new pricing mechanisms and advanced security features of Amazon CloudFront.
* Sharing real Hackathon and enterprise AI implementation experience.

## 3. Speakers

| Speaker | Role / Organization |
| --- | --- |
| Nguyễn Gia Hưng | Solution Architect, AWS Vietnam; founder of SC |
| Tình Trương | Platform Engineer, Gotam X |
| Hải Anh | Pacific Vietnam |
| Nguyễn Tuấn Thịnh | DevOps Engineer |
| Uyển and Thảo | Hackathon team, UTM Morpo project |
| Vy Lam | AI system implementation specialist for VBBank |

The speakers provided practical perspectives across cloud architecture, platform engineering, DevOps, security, Hackathon execution, and AI implementation in banking.

## 4. Key Event Highlights

### 4.1. Career Direction in the AI Era

A key topic was how software engineers should adapt as AI develops quickly. Jevons paradox suggests that when AI reduces the cost of producing software, demand for software may increase instead of decrease. This means AI may create new types of work rather than simply replacing engineers.

Important career directions included:

* Debugging and testing AI-generated code.
* Maintaining systems that integrate AI.
* AI DevOps and Platform Engineering.
* Designing processes, guardrails, and output controls.
* Building real products instead of stopping at demos.

To stay competitive, engineers need strong technical foundations, business understanding, and real products that demonstrate their abilities.

### 4.2. Context Optimization for AI

The event emphasized that effective AI usage is not just about writing longer prompts. Adding too many plugins, rules, or unrelated data can distract the model and lead to inaccurate answers.

Context should be narrow but deep and tied closely to the real business problem. An effective prompt should define:

| Component | Meaning |
| --- | --- |
| Goal | The expected objective |
| Role | The role AI should perform |
| Format | The expected output structure |
| Context | Directly relevant data for the task |
| Constraint | Rules, limits, or standards to follow |

AI mindset and the ability to apply AI correctly are becoming important skills in the job market.

### 4.3. Reducing LLM Variance

An LLM is a probabilistic engine, so its outputs can vary between runs, even when temperature is set to 0. Differences may come from floating-point computation on GPUs, inference optimization, or provider-side infrastructure optimization.

Risk-reduction approaches include:

* Running multiple times to find stable patterns.
* Using JSON Mode when structured output is required.
* Designing downstream validation for AI-generated data.
* Self-hosting models when higher control is needed.
* Continuously testing instead of trusting a single output.

This shows that systems using AI must be designed to handle unstable or incorrectly formatted outputs.

### 4.4. Cost Optimization and Security with Amazon CloudFront

Amazon CloudFront was presented not only as a CDN but also as an important security layer at the edge. Important topics included Flat Rate Pricing, WAF integration, and reducing bill spike risk from DDoS or abnormal traffic.

Key security features included:

* VPC Origin to hide origin servers from the public internet.
* WAF to filter malicious requests.
* mTLS for stronger service authentication.
* Geo restriction to limit access by location.
* Edge protection to reduce DDoS impact closer to users.

These concepts can be applied directly to AWS websites or applications that need performance optimization and stronger security.

### 4.5. 36-Hour Hackathon Experience

The Morpo project was shared as a Hackathon case study. It is an editor that uses AI to generate UI from screenshots or hand-drawn sketches into HTML/CSS. A key feature is allowing users to edit the interface directly instead of asking AI to regenerate everything, which saves tokens and improves user experience.

Lessons from the Hackathon included:

* Focus on one real problem.
* Avoid feature creep.
* Divide work clearly within the team.
* Manage time and health during long competitions.
* Prioritize the core experience instead of adding too many unfinished features.

### 4.6. Enterprise Multi-Agent System

The credit evaluation case study for startups without collateral showed that Multi-Agent architecture is useful when the context is large and requires multiple expert roles, such as finance, market research, and risk management.

Instead of assigning everything to one chatbot, the system can be divided into multiple agents:

* Research agent.
* Financial analysis agent.
* Risk assessment agent.
* Review agent.
* Report synthesis agent.

Enterprises need input/output guardrails, prompt injection prevention, output filtering, API key rotation, and audit trails. Knowledge transfer should also be selective, using only the data that real experts would need.

## 5. Knowledge Gained

### 5.1. Design Mindset

The event reinforced a business-first mindset. When building AI systems, the process should start with who uses the system, what they use it for, and why they need it. This aligns with the Working Backwards approach.

Key lessons included:

* Systems must be secure, reliable, and auditable, not just functional.
* AI decisions should be tied to user needs and business value.
* AI output must be reviewed, especially before production use.
* Security mindset is required when deploying AI in enterprises.

### 5.2. Technical Architecture

Technically, the event clarified several risks and principles for enterprise AI deployment:

* MCP attack vectors and the importance of isolating agent permissions.
* Infrastructure as Code and Terraform for infrastructure management.
* Multi-Agent Orchestration using divide-and-conquer principles.
* Each agent should have a clear role, goal, and permission scope.
* Downstream systems must validate and handle unstable LLM outputs.

### 5.3. Modernization Strategy

Engineers should not rely too much on AI while ignoring core skills such as backend development, security, authentication, password hashing, or JWT. In enterprises, an AI Engineer should first be a Software Engineer who can integrate AI safely.

Before AI implementation, ROI should be calculated with real data to convince stakeholders and avoid trend-driven adoption.

## 6. Application to Internship Work

The knowledge from the event can be applied to the current project in several ways:

* Standardize prompts, remove unnecessary rules, and provide suitable context when using LLMs.
* Apply CloudFront to filter unwanted requests and protect origin servers.
* Design Multi-Agent workflows with research, review, and synthesis agents.
* Practice Terraform to manage infrastructure instead of manual AWS Console operations.
* Add downstream validation for JSON and AI-generated outputs.
* Maintain review processes before using AI outputs in production.

## 7. Personal Experience

The event was highly directional and helped me gain a more realistic understanding of AI capabilities and limitations in enterprise environments. The sharing ranged from IT career strategy to internal credit evaluation workflows in banking.

The content showed that engineers need to adapt to AI while still keeping strong technical foundations. AI can help generate code, analyze data, and summarize information, but production code still requires review, testing, and security checks.

The Hackathon session also provided practical lessons. A product that solves one real problem well is more valuable than a product with too many incomplete features.

## 8. Lessons Learned

After the event, the key lessons were:

* AI does not eliminate the software engineer role, but it requires engineers to improve system design, process management, and business understanding.
* Backend, Security, and Infrastructure as Code are foundations for safe GenAI deployment.
* Enterprise systems must be secure, reliable, and auditable.
* Multi-Agent systems work best when each agent has a clear task, permission scope, and relevant data.
* New technology should be evaluated based on practical value and ROI.

## 9. Conclusion

The event on 23/05 helped me build a more practical mindset about career development, Prompt Engineering, Multi-Agent systems, CloudFront, security, and enterprise AI deployment. These lessons can be applied to my internship by improving LLM usage, strengthening system security, practicing Infrastructure as Code, and designing AI architectures with better control.
