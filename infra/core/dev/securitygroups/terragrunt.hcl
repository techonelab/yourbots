
include "root" {
  path = find_in_parent_folders("root.hcl")
}


locals {
  root_config_path = find_in_parent_folders("root.hcl")
  parent_config = read_terragrunt_config(local.root_config_path)
}
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "import", "terragrunt-info"]
  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
  }
}


terraform {
  source = "../../../../modules/securitygroups"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  prefix = local.parent_config.locals.project_name
  tags   = local.parent_config.locals.common_tags
}