resource "aws_lb" "main" {
    name               = "terraform-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups = var.security_groups
    subnets = var.subnets

    enable_deletion_protection = false

    tags = {
      Name = "terraform-alb"
    }  
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
    name     = "terraform-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
      path = "/"
      healthy_threshold = 2
      unhealthy_threshold = 10
      timeout = 5
      interval = 10
      matcher = "200"
    }  
}