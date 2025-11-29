terraform {
  backend "s3" {}
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_pair_name
  
  associate_public_ip_address = false 

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              EOF
              
  tags = merge(var.tags, {
    Name = "${var.environment}-private-test-instance"
    Tier = "Private"
  })
}