include "root" {
  path = find_in_parent_folders("root.hcl")
}
locals {
  root_config_path = find_in_parent_folders("root.hcl")
  parent_config = read_terragrunt_config(local.root_config_path)

  current_path = get_terragrunt_dir()
  trim = trim(local.current_path, "/")
  part_trim = split("/", local.trim)
  parsed = element(local.part_trim, -2)
  environment = lookup(
    local.parent_config.locals.env_map,
    local.parsed,
    "undefined"
  )
}

terraform {
  source = "../../../../modules/vpc"
}


inputs = {
  vpc_name       = "main-vpc-${local.environment}"
  cidr_block     = "10.192.168.0/22"
  public_subnets = ["10.192.168.0/24", "10.192.169.0/24"]
  private_subnets = ["10.192.170.0/24", "10.192.171.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
  tags = merge(local.parent_config.locals.common_tags, {
    Name = "main-vpc-${local.environment}"
  })
}