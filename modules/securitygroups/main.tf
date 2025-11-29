
terraform {
  backend "s3" {}
}

# Public ALB
resource "aws_security_group" "public_alb" {
  name        = "${var.environment}-public-alb-sg"
  description = "Allows all incoming HTTP/HTTPS traffic from the internet"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.environment}-public-alb-sg"
  })
}

# Ingress Allow HTTP from anywhere
resource "aws_security_group_rule" "public_alb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_alb.id
}

# Ingress Allow HTTPS from anywhere
resource "aws_security_group_rule" "public_alb_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_alb.id
}

# Egress Allow all outbound traffic
resource "aws_security_group_rule" "public_alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All protocols
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_alb.id
}


# Private ALB
resource "aws_security_group" "private_alb" {
  name        = "${var.environment}-private-alb-sg"
  description = "Allows incoming traffic ONLY from the Public ALB Security Group."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.environment}-private-alb-sg"
  })
}

# Ingress Allow HTTP from Public ALB SG ONLY
resource "aws_security_group_rule" "private_alb_ingress_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_alb.id
  security_group_id        = aws_security_group.private_alb.id
}

# Ingress Allow HTTPS from Public ALB SG ONLY
resource "aws_security_group_rule" "private_alb_ingress_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_alb.id
  security_group_id        = aws_security_group.private_alb.id
}

# Egress Allow all outbound traffic
resource "aws_security_group_rule" "private_alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_alb.id
}
