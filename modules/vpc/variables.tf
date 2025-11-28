
variable "vpc_name" {
  description = "A unique name for the VPC."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "azs" {
  description = "List of Availability Zones to deploy resources into."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to apply to all resources in the VPC."
  type        = map(string)
  default     = {}
}