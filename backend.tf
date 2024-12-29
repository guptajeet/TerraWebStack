# Terraform backend configuration for state management

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-123456"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
