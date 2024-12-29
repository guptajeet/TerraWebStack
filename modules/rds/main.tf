# RDS module main configuration

resource "aws_db_subnet_group" "main" {
  name       = "terraform-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Terraform DB subnet group"
  }
}

resource "aws_db_instance" "main" {
  identifier           = "terraform-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.39"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "terraform-rds"
  }
}