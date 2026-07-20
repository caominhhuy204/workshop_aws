---
title: "Event 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 4.2. </b> "
---

{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

# Bài thu hoạch sự kiện định hướng AI, CloudFront và Multi-Agent

## 1. Thông tin chung về sự kiện

**Thời gian:** 23/05/2026  
**Vai trò tham gia:** Người tham dự  
**Chủ đề chính:** Định hướng nghề nghiệp trong kỷ nguyên AI, Prompt Engineering, Multi-Agent System, Amazon CloudFront, bảo mật và kinh nghiệm Hackathon.

Sự kiện tập trung vào cách kỹ sư công nghệ thông tin thích nghi với sự phát triển nhanh của AI, đồng thời chia sẻ các kinh nghiệm thực tế trong việc ứng dụng AI vào doanh nghiệp. Nội dung không chỉ dừng lại ở công cụ AI mà còn mở rộng sang bảo mật, hạ tầng cloud, kiến trúc multi-agent và tư duy xây dựng sản phẩm.

## 2. Mục đích của sự kiện

Sự kiện được tổ chức nhằm giúp người tham dự hiểu rõ hơn các thay đổi của ngành công nghệ trong bối cảnh AI phát triển mạnh. Các mục tiêu chính gồm:

* Định hướng nghề nghiệp và chiến lược phát triển cho kỹ sư CNTT trong kỷ nguyên AI.
* Chia sẻ best practices về Prompt Engineering và cách cung cấp context cho AI hiệu quả.
* Hướng dẫn áp dụng kiến trúc Multi-Agent ở cấp độ doanh nghiệp.
* Cập nhật cơ chế tính phí mới và các tính năng bảo mật nâng cao của Amazon CloudFront.
* Chia sẻ kinh nghiệm thực tế từ Hackathon và các dự án AI trong doanh nghiệp.

## 3. Danh sách diễn giả

| Diễn giả | Vai trò / Đơn vị |
| --- | --- |
| Nguyễn Gia Hưng | Solution Architect, AWS Việt Nam; người sáng lập SC |
| Tình Trương | Platform Engineer, Gotam X |
| Hải Anh | Pacific Việt Nam |
| Nguyễn Tuấn Thịnh | DevOps Engineer |
| Uyển và Thảo | Đội thi Hackathon, dự án UTM Morpo |
| Vy Lam | Chuyên gia triển khai hệ thống AI cho ngân hàng VBBank |

Các diễn giả mang đến góc nhìn đa dạng từ cloud architecture, platform engineering, DevOps, security, hackathon đến triển khai AI trong môi trường ngân hàng.

## 4. Nội dung nổi bật

### 4.1. Định hướng nghề nghiệp trong kỷ nguyên AI

Một nội dung quan trọng của sự kiện là cách kỹ sư phần mềm cần thích nghi khi AI phát triển mạnh. Nghịch lý Jevons cho thấy khi AI làm giảm chi phí tạo phần mềm, nhu cầu phần mềm có thể tăng lên thay vì giảm xuống. Điều này có nghĩa là AI không nhất thiết làm mất vai trò của kỹ sư, mà có thể tạo ra nhiều nhu cầu mới hơn.

Một số hướng công việc được nhấn mạnh gồm:

* Sửa lỗi và kiểm thử code do AI sinh ra.
* Bảo trì hệ thống có tích hợp AI.
* AI DevOps và Platform Engineering.
* Thiết kế quy trình, guardrails và kiểm soát output của AI.
* Xây dựng sản phẩm thực tế thay vì chỉ dừng ở demo.

Để cạnh tranh trong thị trường lao động, kỹ sư cần kết hợp nền tảng kỹ thuật vững, hiểu nghiệp vụ doanh nghiệp và có sản phẩm thực tế chứng minh năng lực.

### 4.2. Tối ưu context cho AI

Sự kiện nhấn mạnh rằng làm việc hiệu quả với AI không chỉ là viết prompt dài hơn. Việc nhồi quá nhiều plugin, rule hoặc dữ liệu không liên quan vào AI có thể làm mô hình mất tập trung và tạo ra câu trả lời sai lệch.

Context nên được thiết kế theo hướng hẹp nhưng sâu, bám sát nghiệp vụ thực tế. Một prompt hiệu quả cần xác định rõ:

| Thành phần | Ý nghĩa |
| --- | --- |
| Goal | Mục tiêu cần đạt được |
| Role | Vai trò mà AI cần đảm nhận |
| Format | Định dạng kết quả mong muốn |
| Context | Dữ liệu liên quan trực tiếp đến bài toán |
| Constraint | Ràng buộc, giới hạn hoặc tiêu chuẩn cần tuân thủ |

AI Mindset và khả năng áp dụng AI đúng cách trở thành kỹ năng quan trọng khi tham gia thị trường lao động.

### 4.3. Giảm thiểu độ lệch của LLM

LLM là một probabilistic engine, vì vậy kết quả có thể thay đổi giữa các lần chạy, kể cả khi temperature được đặt bằng 0. Sai khác có thể đến từ tính toán số thực trên GPU, inference optimization hoặc cách nhà cung cấp tối ưu hạ tầng phía sau.

Một số hướng giảm rủi ro gồm:

* Chạy nhiều lần để tìm kết quả ổn định hơn.
* Sử dụng JSON Mode khi cần output có cấu trúc.
* Thiết kế downstream validation để kiểm tra dữ liệu do AI tạo ra.
* Tự host model trong trường hợp cần kiểm soát cao hơn.
* Kiểm thử liên tục thay vì tin tuyệt đối vào một lần output.

Điều này cho thấy hệ thống sử dụng AI cần được thiết kế để xử lý output sai định dạng hoặc không ổn định.

### 4.4. Tối ưu chi phí và bảo mật với Amazon CloudFront

Amazon CloudFront được giới thiệu không chỉ là dịch vụ CDN mà còn là lớp bảo vệ quan trọng ở edge. Các nội dung đáng chú ý gồm Flat Rate Pricing, tích hợp WAF và khả năng giảm nguy cơ bill spike do DDoS hoặc traffic bất thường.

Một số tính năng bảo mật nổi bật:

* VPC Origin giúp ẩn origin server khỏi public internet.
* WAF hỗ trợ lọc request độc hại.
* mTLS tăng cường xác thực giữa client và service.
* Geo restriction giới hạn truy cập theo khu vực.
* Edge protection giúp chống DDoS gần nguồn truy cập hơn.

Các nội dung này có thể áp dụng trực tiếp cho các website hoặc ứng dụng triển khai trên AWS cần tối ưu hiệu năng và bảo mật.

### 4.5. Kinh nghiệm Hackathon 36 giờ

Dự án Morpo được chia sẻ như một ví dụ thực tế từ Hackathon. Đây là trình editor tạo giao diện bằng AI từ ảnh chụp hoặc bản vẽ tay sang HTML/CSS. Điểm hay của dự án là người dùng có thể chỉnh sửa trực tiếp trên giao diện thay vì yêu cầu AI tạo lại toàn bộ, giúp tiết kiệm token và cải thiện trải nghiệm.

Các bài học rút ra từ Hackathon gồm:

* Tập trung vào một vấn đề thực tế.
* Tránh feature creep.
* Phân chia công việc rõ ràng trong nhóm.
* Quản lý thời gian và sức khỏe trong cuộc thi kéo dài.
* Ưu tiên trải nghiệm cốt lõi thay vì thêm quá nhiều tính năng chưa hoàn thiện.

### 4.6. Xây dựng Enterprise Multi-Agent System

Case study về đánh giá tín dụng cho startup không có tài sản thế chấp cho thấy Multi-Agent phù hợp khi bài toán có context lớn và cần nhiều vai trò chuyên môn khác nhau, ví dụ tài chính, nghiên cứu thị trường và quản trị rủi ro.

Thay vì giao toàn bộ nhiệm vụ cho một chatbot, hệ thống có thể chia thành nhiều agent:

* Agent nghiên cứu dữ liệu.
* Agent phân tích tài chính.
* Agent đánh giá rủi ro.
* Agent review kết quả.
* Agent tổng hợp báo cáo.

Doanh nghiệp cần bổ sung guardrails cho input/output, chống prompt injection, output filtering, rotate API key và audit trail. Knowledge transfer cũng cần chọn lọc đúng dữ liệu mà chuyên gia thực tế sẽ dùng, không nên đưa nguyên tài liệu dài cho AI nếu không cần thiết.

## 5. Những kiến thức học được

### 5.1. Tư duy thiết kế

Sự kiện giúp tôi hiểu rõ hơn tư duy business-first. Khi xây dựng hệ thống AI, cần bắt đầu bằng các câu hỏi: ai sử dụng, sử dụng để làm gì và tại sao cần sử dụng. Đây cũng là tinh thần của phương pháp Working Backwards.

Các bài học chính gồm:

* Hệ thống không chỉ cần chạy được mà còn phải an toàn, đáng tin cậy và có audit trail.
* Mọi quyết định áp dụng AI cần gắn với nhu cầu người dùng và giá trị kinh doanh.
* AI output luôn cần được review, đặc biệt trước khi đưa vào production.
* Security mindset là yêu cầu bắt buộc khi triển khai AI trong doanh nghiệp.

### 5.2. Kiến trúc kỹ thuật

Về kỹ thuật, sự kiện giúp tôi hiểu thêm các rủi ro và nguyên tắc khi triển khai AI ở cấp doanh nghiệp:

* MCP attack vector và tầm quan trọng của việc cô lập quyền truy cập của agent.
* Infrastructure as Code và vai trò của Terraform trong quản lý hạ tầng.
* Multi-Agent Orchestration theo nguyên tắc chia để trị.
* Mỗi agent cần có role, goal và phạm vi quyền rõ ràng.
* Downstream system cần kiểm tra và xử lý output không ổn định từ LLM.

### 5.3. Chiến lược hiện đại hóa

Không nên quá phụ thuộc vào AI mà bỏ qua các kỹ năng nền tảng như backend, security, authentication, mã hóa mật khẩu hoặc JWT. AI Engineer trong doanh nghiệp trước hết vẫn cần là Software Engineer có khả năng tích hợp AI an toàn.

Trước khi triển khai AI, cần tính ROI bằng dữ liệu thực tế để thuyết phục các bên liên quan và tránh triển khai theo phong trào.

## 6. Ứng dụng vào công việc và dự án

Các kiến thức từ sự kiện có thể áp dụng vào dự án hiện tại như sau:

* Chuẩn hóa prompt, loại bỏ rule thừa và cung cấp context phù hợp khi sử dụng LLM.
* Áp dụng CloudFront để lọc request không mong muốn và bảo vệ origin server.
* Thiết kế Multi-Agent theo hướng chia quy trình thành agent nghiên cứu, agent review và agent tổng hợp.
* Học và luyện tập Terraform để quản lý hạ tầng thay cho thao tác thủ công trên AWS Console.
* Bổ sung downstream validation cho JSON và các output do AI tạo ra.
* Duy trì quy trình review trước khi đưa AI output vào production.

## 7. Trải nghiệm cá nhân trong sự kiện

Sự kiện mang tính định hướng cao, giúp tôi có góc nhìn thực tế hơn về khả năng và giới hạn của AI trong môi trường doanh nghiệp. Các chia sẻ bao quát từ chiến lược nghề nghiệp trong ngành IT đến quy trình đánh giá tín dụng nội bộ của ngân hàng.

Nội dung làm rõ rằng kỹ sư cần thích nghi với AI nhưng vẫn phải giữ nền tảng kỹ thuật cốt lõi. AI có thể hỗ trợ sinh code, phân tích và tổng hợp, nhưng code đưa vào production vẫn cần review, kiểm thử và bảo mật.

Phần Hackathon cũng mang lại nhiều kinh nghiệm thực tế. Một sản phẩm giải quyết tốt một vấn đề cụ thể thường có giá trị hơn một sản phẩm có quá nhiều tính năng nhưng chưa hoàn thiện.

## 8. Bài học rút ra

Sau sự kiện, tôi rút ra một số bài học quan trọng:

* AI không làm kỹ sư phần mềm hết vai trò, nhưng yêu cầu kỹ sư nâng cấp năng lực thiết kế hệ thống, quản lý quy trình và hiểu nghiệp vụ.
* Backend, Security và Infrastructure as Code là nền tảng để triển khai GenAI an toàn.
* Hệ thống doanh nghiệp phải an toàn, đáng tin cậy và có audit trail rõ ràng.
* Multi-Agent chỉ hiệu quả khi mỗi agent có nhiệm vụ, quyền hạn và dữ liệu phù hợp.
* Công nghệ mới cần được đánh giá bằng giá trị thực tế và ROI.

## 9. Kết luận

Sự kiện ngày 23/05 giúp tôi xây dựng tư duy thực tế hơn về nghề nghiệp, Prompt Engineering, Multi-Agent, CloudFront, bảo mật và cách triển khai AI ở cấp độ doanh nghiệp. Những kiến thức này có thể áp dụng vào quá trình thực tập thông qua việc cải thiện cách sử dụng LLM, tăng cường bảo mật hệ thống, luyện tập Infrastructure as Code và thiết kế kiến trúc AI có kiểm soát hơn.
