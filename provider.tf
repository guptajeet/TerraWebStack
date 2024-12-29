# Main Terraform configuration file
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.82.2"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}