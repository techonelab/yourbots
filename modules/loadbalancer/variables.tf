
variable "vpc_id" {
  description = "The ID of the VPC where the ALBs will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the internet-facing ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the internal-facing ALB."
  type        = list(string)
}

variable "public_alb_sg_id" {
  description = "The ID of the Security Group for the Public ALB."
  type        = string
}

variable "private_alb_sg_id" {
  description = "The ID of the Security Group for the Private ALB."
  type        = string
}

variable "prefix" {
  description = "A prefix used for naming resources (usually the project name)."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}