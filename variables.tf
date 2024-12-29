variable "aws_region" {
  description = "the aws region to deploy resources"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR block for private subnets"
  type = list(string)
  default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "public_subnet_cidrs" {
  description = "CIDR blcok for publicj subnets"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "availability_zones" {
    description = "AZ for the subnets"
    type = list(string)
    default = [ "us-east-1a", "us-east-1b" ]
  
}

variable "ec2_instance_type" {
  description = "Instance type of ec2 instances"
  default = "t2.micro"
}

variable "ec2_ami" {
    description = "The ID of the AMI to use for the EC2 instance"
    default = "ami-01816d07b1128cd2d" #amazon linux
}

variable "db_name" {
  description = "Name of the database"
  default     = "mydb"
}

variable "db_username" {
  description = "Username for the database"
}

variable "db_password" {
  description = "Password for the database"
}