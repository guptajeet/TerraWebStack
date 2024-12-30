resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "terraform-state-bucket-123456"
}
/*
# bastion host
resource "aws_instance" "bastion" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id  # Use the first public subnet
  key_name      = "your-key-pair-name"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  
  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP_ADDRESS/32"]  # Replace with your IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

*/

# VPC Creation

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "terraform-vpc"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "terraform-igw"
  }
}

# Private Subnet

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = var.private_subnet_cidrs[count.index]
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "terraform-private-subnet-${count.index + 1}"
  }
}

# Public Subnet

resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = var.public_subnet_cidrs[count.index]
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet-${count.index + 1}"
  }
}

# NAT Gateway

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "terraform-nat-gateway"
  }
}

# ELaStic IP for NAT Gateway

resource "aws_eip" "nat" {
  domain = "vpc"
  count  = 1

  tags = {
    Name = "terraform-nat-eip"
  }
}

# Route table for public subnets

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "terraform-public-route-table"
  }
}

# Assosiate public subnets with public route table

resource "aws_route_table_association" "piblic" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route table for private subnets

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "terraform-private-route-table"
  }
}

# Assosiate private subnets with private route table

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Security group for ALB
/*
Ingress: If you specify 0.0.0.0/0 in an ingress rule, it means that traffic from any IP address on the internet is allowed.
Egress: If you specify 0.0.0.0/0 in an egress rule, it means that the resource can connect to any IP address on the internet.
*/
resource "aws_security_group" "alb" {
  name        = "terraform-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # koi bhi traffic aa skta h ya allowed h
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # alb khi bhi connect ho skta h 
  }

  tags = {
    Name = "terraform-alb-sg"
  }
}

# Security group for EC2

resource "aws_security_group" "ec2" {
  name        = "terraform-ec2-sg"
  description = "SG for ec2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # bs alb aa skta h ya allowed h
    #cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # ec2 khi bhi connect ho skta h 
  }

  tags = {
    Name = "terraform-ec2-sg"
  }
}

resource "aws_security_group_rule" "ec2_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Consider restricting this to your IP address
  security_group_id = aws_security_group.ec2.id
}
/*
resource "aws_security_group_rule" "allow_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.ec2.id
}
*/
# Security group for RDS

resource "aws_security_group" "rds" {
  name        = "terraform-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-rds-sg"
  }
}

# ALB

module "alb" {
  source = "./modules/alb"

  vpc_id          = aws_vpc.main.id
  subnets         = aws_subnet.public[*].id
  security_groups = [aws_security_group.alb.id]
}


# EC2 instances

module "ec2_web" {
  source = "./modules/ec2"

  ssm_role_name         = "SSMRoleForWebEC2"
  instance_profile_name = "WebSSMInstanceProfile"
  ami                   = var.ec2_ami
  instance_type         = var.ec2_instance_type
  #subnet_id              = aws_subnet.private[0].id
  subnet_id              = aws_subnet.public[1].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  user_data              = file("${path.module}/scripts/init_web.sh")

  tags = {
    Name = "terraform-ec2-web"
    Role = "web"
  }
}

module "ec2_app" {
  source = "./modules/ec2"

  ssm_role_name         = "SSMRoleForAppEC2"
  instance_profile_name = "AppSSMInstanceProfile"
  ami                   = var.ec2_ami
  instance_type         = var.ec2_instance_type
  #subnet_id              = aws_subnet.private[1].id
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  user_data              = file("${path.module}/scripts/init_app.sh")

  tags = {
    Name = "terraform-ec2-app"
    Role = "app"
  }
}



# RDS instance

module "rds" {
  source = "./modules/rds"

  subnet_ids             = aws_subnet.private[*].id
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
}

# Register EC2 instance with ALB target group

resource "aws_lb_target_group_attachment" "ec2" {
  count            = 2
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2_app.instance_id
  port             = 80
}
