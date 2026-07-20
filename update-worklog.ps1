$weeks = @(
  @{
    N = 1
    Dates = '15/04/2026 - 23/04/2026'
    ShortDates = '15/04 - 23/04'
    ViTitle = 'Tìm hiểu tổng quan về điện toán đám mây và nền tảng AWS'
    EnTitle = 'Cloud computing and AWS platform overview'
    ViItems = @(
      'Tìm hiểu tổng quan về điện toán đám mây và nền tảng AWS.'
      'Nghiên cứu kiến trúc hạ tầng và các dịch vụ cơ bản phục vụ triển khai hệ thống.'
    )
    EnItems = @(
      'Studied the overview of cloud computing and the AWS platform.'
      'Researched infrastructure architecture and basic services used for system deployment.'
    )
  }
  @{
    N = 2
    Dates = '24/04/2026 - 01/05/2026'
    ShortDates = '24/04 - 01/05'
    ViTitle = 'AWS Management Console, IAM, Region và Security Group'
    EnTitle = 'AWS Management Console, IAM, Region, and Security Group'
    ViItems = @(
      'Tìm hiểu AWS Management Console, IAM, Region và Security Group.'
      'Thực hành quản lý người dùng, phân quyền và cấu hình bảo mật ban đầu.'
    )
    EnItems = @(
      'Studied AWS Management Console, IAM, Region, and Security Group.'
      'Practiced user management, permission assignment, and initial security configuration.'
    )
  }
  @{
    N = 3
    Dates = '02/05/2026 - 09/05/2026'
    ShortDates = '02/05 - 09/05'
    ViTitle = 'Triển khai EC2, S3 và cấu hình quyền truy cập'
    EnTitle = 'EC2, S3 deployment, and access configuration'
    ViItems = @(
      'Triển khai các dịch vụ EC2 và S3 trên AWS.'
      'Cấu hình máy chủ, lưu trữ dữ liệu và thiết lập quyền truy cập.'
    )
    EnItems = @(
      'Deployed EC2 and S3 services on AWS.'
      'Configured servers, data storage, and access permissions.'
    )
  }
  @{
    N = 4
    Dates = '10/05/2026 - 17/05/2026'
    ShortDates = '10/05 - 17/05'
    ViTitle = 'Amazon VPC, Route 53, AWS CLI và CloudWatch'
    EnTitle = 'Amazon VPC, Route 53, AWS CLI, and CloudWatch'
    ViItems = @(
      'Tìm hiểu Amazon VPC, Route 53, AWS CLI và CloudWatch.'
      'Thực hành cấu hình mạng và giám sát tài nguyên hệ thống.'
    )
    EnItems = @(
      'Studied Amazon VPC, Route 53, AWS CLI, and CloudWatch.'
      'Practiced network configuration and system resource monitoring.'
    )
  }
  @{
    N = 5
    Dates = '18/05/2026 - 25/05/2026'
    ShortDates = '18/05 - 25/05'
    ViTitle = 'Amazon RDS, DynamoDB và quản lý cơ sở dữ liệu'
    EnTitle = 'Amazon RDS, DynamoDB, and database management'
    ViItems = @(
      'Nghiên cứu Amazon RDS và DynamoDB.'
      'Thực hành kết nối, sao lưu và quản lý cơ sở dữ liệu trên AWS.'
    )
    EnItems = @(
      'Researched Amazon RDS and DynamoDB.'
      'Practiced database connection, backup, and management on AWS.'
    )
  }
  @{
    N = 6
    Dates = '26/05/2026 - 02/06/2026'
    ShortDates = '26/05 - 02/06'
    ViTitle = 'Triển khai ứng dụng trên EC2 và kết nối Amazon RDS'
    EnTitle = 'Application deployment on EC2 and Amazon RDS connection'
    ViItems = @(
      'Triển khai ứng dụng trên EC2 và kết nối với Amazon RDS.'
      'Theo dõi hoạt động hệ thống và xử lý các lỗi cơ bản.'
    )
    EnItems = @(
      'Deployed an application on EC2 and connected it to Amazon RDS.'
      'Monitored system operation and handled basic errors.'
    )
  }
  @{
    N = 7
    Dates = '03/06/2026 - 11/06/2026'
    ShortDates = '03/06 - 11/06'
    ViTitle = 'Git/GitHub và quy trình CI/CD'
    EnTitle = 'Git/GitHub and CI/CD workflow'
    ViItems = @(
      'Tìm hiểu Git/GitHub và quy trình quản lý mã nguồn.'
      'Nghiên cứu các khái niệm CI/CD và cập nhật ứng dụng.'
    )
    EnItems = @(
      'Studied Git/GitHub and source code management workflow.'
      'Researched CI/CD concepts and application update workflow.'
    )
  }
  @{
    N = 8
    Dates = '12/06/2026 - 19/06/2026'
    ShortDates = '12/06 - 19/06'
    ViTitle = 'Giám sát hệ thống bằng CloudWatch và CloudTrail'
    EnTitle = 'System monitoring with CloudWatch and CloudTrail'
    ViItems = @(
      'Thực hành giám sát hệ thống bằng CloudWatch và CloudTrail.'
      'Thiết lập cảnh báo và phân tích nhật ký hoạt động.'
    )
    EnItems = @(
      'Practiced system monitoring with CloudWatch and CloudTrail.'
      'Configured alerts and analyzed activity logs.'
    )
  }
  @{
    N = 9
    Dates = '20/06/2026 - 27/06/2026'
    ShortDates = '20/06 - 27/06'
    ViTitle = 'Triển khai website tĩnh với Amazon S3 và CloudFront'
    EnTitle = 'Static website deployment with Amazon S3 and CloudFront'
    ViItems = @(
      'Triển khai website tĩnh với Amazon S3 và CloudFront.'
      'Tối ưu hiệu năng phân phối nội dung và quản lý dữ liệu.'
    )
    EnItems = @(
      'Deployed a static website with Amazon S3 and CloudFront.'
      'Optimized content delivery performance and data management.'
    )
  }
  @{
    N = 10
    Dates = '28/06/2026 - 05/07/2026'
    ShortDates = '28/06 - 05/07'
    ViTitle = 'Tự động hóa triển khai với CodeDeploy và CodePipeline'
    EnTitle = 'Deployment automation with CodeDeploy and CodePipeline'
    ViItems = @(
      'Xây dựng quy trình triển khai tự động với CodeDeploy và CodePipeline.'
      'Tích hợp GitHub và kiểm thử quy trình Deploy.'
    )
    EnItems = @(
      'Built an automated deployment workflow with CodeDeploy and CodePipeline.'
      'Integrated GitHub and tested the deployment workflow.'
    )
  }
  @{
    N = 11
    Dates = '06/07/2026 - 13/07/2026'
    ShortDates = '06/07 - 13/07'
    ViTitle = 'Docker và triển khai container trên EC2'
    EnTitle = 'Docker and container deployment on EC2'
    ViItems = @(
      'Tìm hiểu Docker và quy trình đóng gói ứng dụng.'
      'Triển khai và quản lý container trên máy chủ EC2.'
    )
    EnItems = @(
      'Studied Docker and the application containerization process.'
      'Deployed and managed containers on an EC2 server.'
    )
  }
  @{
    N = 12
    Dates = '14/07/2026 - 21/07/2026'
    ShortDates = '14/07 - 21/07'
    ViTitle = 'Tổng hợp kết quả thực tập và hoàn thiện báo cáo'
    EnTitle = 'Internship result summary and report completion'
    ViItems = @(
      'Tổng hợp kết quả thực tập và rà soát toàn bộ hệ thống.'
      'Hoàn thiện báo cáo và chuẩn bị nội dung trình bày.'
    )
    EnItems = @(
      'Summarized internship results and reviewed the entire system.'
      'Completed the report and prepared presentation content.'
    )
  }
)

function Get-ListMarkdown($Items) {
  return (($Items | ForEach-Object { "* $_" }) -join "`r`n")
}

function Get-TableRows($Items, $Language) {
  $rows = foreach ($week in $Items) {
    if ($Language -eq 'vi') {
      "| Tuần $($week.N) | $($week.ShortDates) | [$($week.ViTitle)](1.$($week.N)-week$($week.N)/) |"
    } else {
      "| Week $($week.N) | $($week.ShortDates) | [$($week.EnTitle)](1.$($week.N)-week$($week.N)/) |"
    }
  }
  return ($rows -join "`r`n")
}

$worklogVi = @"
---
title: "Nhật ký công việc"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1. </b> "
---

Nhật ký công việc ghi lại quá trình thực tập trong 12 tuần. Nội dung được cập nhật theo phiếu theo dõi tiến độ thực tập tốt nghiệp, tập trung vào AWS Cloud, triển khai hệ thống, giám sát, tự động hóa, Docker và hoàn thiện báo cáo.

| Tuần | Thời gian | Nội dung |
| --- | --- | --- |
$(Get-TableRows $weeks 'vi')
"@

$worklogEn = @"
---
title: "Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1. </b> "
---

This worklog records the 12-week internship progress. The content is updated from the internship progress tracking form and focuses on AWS Cloud, system deployment, monitoring, automation, Docker, and report completion.

| Week | Period | Content |
| --- | --- | --- |
$(Get-TableRows $weeks 'en')
"@

[IO.File]::WriteAllText('content/1-Worklog/_index.vi.md', $worklogVi, [Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText('content/1-Worklog/_index.md', $worklogEn, [Text.UTF8Encoding]::new($false))

foreach ($week in $weeks) {
  $weight = $week.N
  $pre = " <b> 1.$($week.N). </b> "
  $dir = Join-Path 'content/1-Worklog' "1.$($week.N)-Week$($week.N)"
  New-Item -ItemType Directory -Force -Path $dir | Out-Null

  $vi = @"
---
title: "Worklog Tuần $($week.N)"
date: 2024-01-01
weight: $weight
chapter: false
pre: "$pre"
---

### Thời gian thực hiện

$($week.Dates)

### Nội dung thực hiện

$(Get-ListMarkdown $week.ViItems)

### Kết quả đạt được

* Hoàn thành các nội dung theo kế hoạch tuần $($week.N).
* Ghi nhận kết quả thực hiện để phục vụ báo cáo thực tập tốt nghiệp.
"@

  $en = @"
---
title: "Week $($week.N) Worklog"
date: 2024-01-01
weight: $weight
chapter: false
pre: "$pre"
---

### Implementation Period

$($week.Dates)

### Completed Content

$(Get-ListMarkdown $week.EnItems)

### Achievements

* Completed the planned content for week $($week.N).
* Recorded the implementation results for the internship graduation report.
"@

  [IO.File]::WriteAllText((Join-Path $dir '_index.vi.md'), $vi, [Text.UTF8Encoding]::new($false))
  [IO.File]::WriteAllText((Join-Path $dir '_index.md'), $en, [Text.UTF8Encoding]::new($false))
}

