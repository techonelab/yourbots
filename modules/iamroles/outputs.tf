output "ecs_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role."
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role."
  value       = aws_iam_role.ecs_task_role.arn
}

output "ssm_role" {
  description = "Name of ssm role for EC2."
  value       = aws_iam_instance_profile.ssm_profile.name
}