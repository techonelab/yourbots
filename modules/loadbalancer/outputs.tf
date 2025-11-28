# ---------------------------------------------------------------------------------------------------------------------
# LOAD BALANCER MODULE OUTPUTS (modules/load-balancers)
# ---------------------------------------------------------------------------------------------------------------------

output "public_alb_arn" {
  description = "The ARN of the public Application Load Balancer."
  value       = aws_lb.public.arn
}

output "public_alb_dns_name" {
  description = "The DNS name of the public Application Load Balancer."
  value       = aws_lb.public.dns_name
}

output "private_alb_arn" {
  description = "The ARN of the private Application Load Balancer."
  value       = aws_lb.private.arn
}