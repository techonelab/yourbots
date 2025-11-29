variable "environment" {
  description = "A unique name for the iam exec role"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources in the VPC."
  type        = map(string)
  default     = {}
}