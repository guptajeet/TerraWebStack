# EC2 module main configuration

#IAM

resource "aws_iam_role" "ssm_role" {
  name = var.ssm_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ssm_role.name
}




resource "aws_instance" "main" {
  
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = base64encode(var.user_data)

  tags = var.tags

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  associate_public_ip_address = true
  user_data_replace_on_change = true
}

resource "aws_eip" "main" {
  domain   = "vpc"
  instance = aws_instance.main.id
}

resource "aws_eip_association" "main" {
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.main.id
}
