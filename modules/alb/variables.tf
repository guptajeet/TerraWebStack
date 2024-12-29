variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnets" {
    description = "List of subnet IDs for ALB"
    type        = list(string)  
}

variable "security_groups" {
  description = "list of sg ids for the alb"
  type = list(string)
}

