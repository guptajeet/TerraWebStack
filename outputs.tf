# Outputs for the main Terraform configuration

#EC2
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "ec2_web_instance_id" {
  description = "ID of the web EC2 instance"
  value       = module.ec2_web.instance_id
}

output "ec2_app_instance_id" {
  description = "ID of the app EC2 instance"
  value       = module.ec2_app.instance_id
}

output "ec2_web_instance_public_ips" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_web.instance_public_ip
}

output "ec2_app_instance_public_ips" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_app.instance_public_ip
}

output "ec2_web_private_public_ips" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_web.instance_private_ip
}

output "ec2_app_private_public_ips" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_app.instance_private_ip
}

#ALB

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = module.alb.target_group_arn
}

#RDS

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "rds_instance_name" {
  description = "The name of the RDS instance"
  value       = module.rds.db_instance_name
}

output "rds_instance_username" {
  description = "The master username for the RDS instance"
  value       = module.rds.db_instance_username
}