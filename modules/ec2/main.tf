# EC2 module main configuration

resource "aws_instance" "main" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids

  user_data = var.user_data

  tags = var.tags

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

resource "aws_eip" "main" {
  domain = "vpc"
  instance = aws_instance.main.id
}

resource "aws_eip_association" "main" {
  instance_id = aws_instance.main.id
  allocation_id = aws_eip.main.id
}