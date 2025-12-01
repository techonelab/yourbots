output "public_alb_sg_id" {
  description = "The ID of the public ALB Security Group."
  value       = aws_security_group.public_alb.id
}

output "private_alb_sg_id" {
  description = "The ID of the private ALB Security Group."
  value       = aws_security_group.private_alb.id
}