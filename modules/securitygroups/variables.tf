variable "vpc_id" {
  description = "The ID of the VPC to create the security groups in."
  type        = string
}

variable "prefix" {
  description = "A prefix used for naming resources (usually the VPC name or project name)."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "List of Availability Zones to deploy resources into."
  type        = list(string)
}