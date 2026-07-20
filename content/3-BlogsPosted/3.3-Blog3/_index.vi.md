---
title: "Blog 3"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---
{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

# Amazon EC2 Auto Scaling Group trong kiến trúc AWS

## 1. Tổng quan nội dung nghiên cứu

Trong quá trình tìm hiểu các dịch vụ thuộc nhóm Amazon EC2, Amazon EC2 Auto Scaling Group là một thành phần quan trọng giúp hệ thống có khả năng mở rộng và tự phục hồi tốt hơn. Ban đầu, Auto Scaling thường được hiểu đơn giản là cơ chế tự động tạo thêm EC2 khi hệ thống có nhiều người dùng. Tuy nhiên, sau khi nghiên cứu kỹ hơn, có thể thấy Auto Scaling Group không chỉ phục vụ việc tăng số lượng máy chủ, mà còn quản lý toàn bộ vòng đời của các EC2 instance trong một nhóm.

Một website hoặc ứng dụng có thể chạy trên một EC2 duy nhất nếu lưu lượng truy cập nhỏ. Tuy nhiên, khi lượng người dùng tăng đột biến hoặc khi máy chủ gặp sự cố, việc phụ thuộc vào một EC2 đơn lẻ sẽ tạo ra rủi ro về tính sẵn sàng. Auto Scaling Group được thiết kế để giải quyết vấn đề này bằng cách duy trì số lượng instance mong muốn, tự động mở rộng khi tải tăng và thay thế instance bị lỗi khi cần thiết.

![Kiến trúc sử dụng Auto Scaling Group sau Application Load Balancer](/images/blog3-auto-scaling-2.jpg)

## 2. Vấn đề khi chỉ sử dụng một EC2

Một EC2 có thể đủ cho website cá nhân, hệ thống demo hoặc ứng dụng nội bộ nhỏ. Tuy nhiên, khi triển khai hệ thống phục vụ nhiều người dùng, việc chỉ sử dụng một EC2 có thể gặp các hạn chế sau:

* Nếu instance bị lỗi, toàn bộ ứng dụng có thể ngừng hoạt động.
* Khi lưu lượng truy cập tăng đột biến, máy chủ có thể quá tải.
* Việc mở rộng thủ công mất thời gian và phụ thuộc vào người vận hành.
* Khó tối ưu chi phí khi lưu lượng thay đổi theo thời gian.
* Không đáp ứng tốt yêu cầu high availability trong môi trường production.

Vì vậy, với các hệ thống cần khả năng chịu tải và độ sẵn sàng cao, Auto Scaling Group là một thành phần rất đáng cân nhắc.

## 3. Auto Scaling Group không chỉ để tăng thêm EC2

Điểm quan trọng khi tìm hiểu Auto Scaling Group là dịch vụ này không chỉ có nhiệm vụ tạo thêm máy chủ. Nó quản lý vòng đời của các EC2 instance theo cấu hình mà quản trị viên đặt ra.

Auto Scaling Group có thể thực hiện các chức năng chính sau:

| Chức năng | Ý nghĩa |
| --- | --- |
| Scale out | Tự động tăng số lượng EC2 khi tải hệ thống tăng |
| Scale in | Tự động giảm số lượng EC2 khi tải giảm |
| Health check | Kiểm tra tình trạng hoạt động của instance |
| Self-healing | Thay thế instance bị lỗi bằng instance mới |
| Desired capacity | Duy trì số lượng instance mong muốn |
| Integration with Load Balancer | Phân phối request đến các instance khỏe mạnh |

Nhờ các chức năng này, Auto Scaling Group giúp hệ thống vận hành ổn định hơn mà không cần quản trị viên theo dõi thủ công liên tục.

## 4. Khả năng tự phục hồi của hệ thống

Một trong những giá trị quan trọng nhất của Auto Scaling Group là khả năng tự phục hồi. Ví dụ, hệ thống được cấu hình chạy với 3 EC2 instance. Nếu một instance bị lỗi hoặc không vượt qua health check, Auto Scaling Group có thể tự động loại bỏ instance đó và khởi tạo một instance mới để thay thế.

Quá trình này giúp hệ thống duy trì đúng số lượng máy chủ cần thiết. Khi kết hợp với Application Load Balancer, request từ người dùng sẽ được phân phối đến các instance còn khỏe mạnh, nhờ đó giảm tác động của sự cố lên trải nghiệm người dùng.

## 5. Vai trò của Amazon CloudWatch

Auto Scaling Group không tự đoán khi nào cần mở rộng hoặc thu hẹp hệ thống. Việc mở rộng thường dựa trên metric được thu thập và giám sát bởi Amazon CloudWatch.

Một số metric thường được dùng để kích hoạt scaling policy gồm:

* CPU Utilization tăng vượt ngưỡng, ví dụ trên 70%.
* Số lượng request tăng cao.
* Network traffic tăng mạnh.
* Load balancer target response time tăng.
* Custom metric do ứng dụng tự gửi lên CloudWatch.

Khi metric vượt ngưỡng đã cấu hình, CloudWatch có thể kích hoạt scaling policy để Auto Scaling Group tạo thêm EC2. Khi tải giảm, Auto Scaling Group có thể giảm số lượng instance để tiết kiệm chi phí.

## 6. Kết hợp với Application Load Balancer

Trong kiến trúc production, Auto Scaling Group thường được kết hợp với Application Load Balancer. Load Balancer nhận request từ người dùng và phân phối đến các EC2 instance trong Auto Scaling Group.

Sự kết hợp này mang lại một số lợi ích:

* Request được phân phối đều đến nhiều instance.
* Instance lỗi có thể bị loại khỏi luồng nhận request.
* Hệ thống có thể mở rộng mà không làm thay đổi endpoint người dùng truy cập.
* Việc triển khai ứng dụng trở nên linh hoạt hơn.
* Tăng tính sẵn sàng và khả năng chịu lỗi cho hệ thống.

## 7. Khi nào nên và không nên dùng Auto Scaling Group

Auto Scaling Group rất hữu ích, nhưng không phải mọi hệ thống đều cần dùng ngay từ đầu. Với website cá nhân, website nội bộ, hệ thống demo hoặc đồ án nhỏ, một EC2 duy nhất có thể đã đủ đáp ứng nhu cầu.

Việc triển khai Auto Scaling Group trong hệ thống nhỏ đôi khi làm tăng độ phức tạp vì cần cấu hình thêm Launch Template, Load Balancer, Security Group, scaling policy và health check. Ngoài ra, chi phí cũng có thể tăng nếu cấu hình số lượng instance tối thiểu lớn hơn nhu cầu thực tế.

Ngược lại, Auto Scaling Group nên được cân nhắc khi hệ thống có các yêu cầu sau:

* Lưu lượng truy cập thay đổi theo thời gian.
* Cần đảm bảo tính sẵn sàng cao.
* Không muốn phụ thuộc vào một máy chủ duy nhất.
* Cần tự động thay thế instance lỗi.
* Cần tối ưu chi phí bằng cách tăng giảm tài nguyên theo tải thực tế.

## 8. Bài học rút ra

Sau khi tìm hiểu Auto Scaling Group, có thể thấy việc xây dựng hệ thống trên cloud không chỉ dừng lại ở việc tạo một EC2 và chạy ứng dụng. Điều quan trọng hơn là thiết kế hệ thống có khả năng mở rộng khi người dùng tăng và có khả năng tự phục hồi khi tài nguyên gặp sự cố.

Auto Scaling Group thể hiện rõ tư duy thiết kế của AWS: hệ thống không chỉ cần chạy được, mà còn cần sẵn sàng trước thay đổi của thực tế. Khi kết hợp với CloudWatch và Application Load Balancer, Auto Scaling Group giúp ứng dụng vận hành ổn định hơn, giảm công sức quản trị và cải thiện khả năng chịu tải.

## 9. Kết luận

Amazon EC2 Auto Scaling Group không đơn thuần là dịch vụ tự động tạo thêm EC2. Đây là một giải pháp giúp hệ thống tự động mở rộng theo nhu cầu sử dụng, tăng tính sẵn sàng, tự phục hồi khi instance gặp lỗi và tối ưu chi phí khi lưu lượng truy cập thay đổi.

Đối với các ứng dụng thực tế trên AWS, đặc biệt là hệ thống production hoặc hệ thống có lượng người dùng biến động, Auto Scaling Group là một dịch vụ quan trọng cần tìm hiểu và áp dụng đúng cách.


**T?i li?u tham kh?o:** <https://aws.amazon.com/blogs/compute/introducing-instance-refresh-for-ec2-auto-scaling/>
