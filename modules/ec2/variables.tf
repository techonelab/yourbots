variable "private_subnet_ids" {
  description = "A list of private subnet IDs."
  type        = list(string)
}

variable "private_sg_id" {
  description = "The Security Group ID for the private instance (e.g., private access)."
  type        = string
}

variable "key_pair_name" {
  description = "The name of the SSH Key Pair used for EC2 access."
  type        = string
}

variable "environment" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "ssm_instance_profile_name" {
  description = "IAM profile used for ec2 sampler."
  type        = string
}