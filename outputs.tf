# alb/outputs.tf

# output load balancer dns name
output "alb_dns_name" {
  value = aws_lb.test.dns_name
}

# output database endpoint
output "db_endpoint" {
  value = aws_db_instance.db_1.endpoint
}

# output database port
output "db_port" {
  value = aws_db_instance.db_1.port
}

output "instance_1_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_server_1.id
}

output "instance_2_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_server_2.id
}

output "instance_1_public_ip" {
  description = "Public IP address of EC2 instance 1"
  value       = aws_instance.my_server_1.public_ip
}

output "instance_2_public_ip" {
  description = "Public IP address of EC2 instance 2"
  value       = aws_instance.my_server_2.public_ip
}















