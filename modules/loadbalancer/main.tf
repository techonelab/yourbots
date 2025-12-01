terraform {
  backend "s3" {}
}

# Public
resource "aws_lb" "public" {
  name               = "${var.environment}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnet_ids
  
  tags = merge(var.tags, {
    Name = "${var.environment}-public-alb"
  })
}

# Default Target Group for public ALB
resource "aws_lb_target_group" "public_default" {
  name        = "${var.environment}-public-default-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener for HTTP traffic on Public ALB
resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_default.arn
  }
}

# Private
resource "aws_lb" "private" {
  name               = "${var.environment}-private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.private_alb_sg_id]
  subnets            = var.private_subnet_ids
  
  tags = merge(var.tags, {
    Name = "${var.environment}-private-alb"
  })
}

# Default Target Group for the Private ALB
resource "aws_lb_target_group" "private_default" {
  name        = "${var.environment}-private-default-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener for HTTP traffic on Private ALB
resource "aws_lb_listener" "private_http" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_default.arn
  }
}