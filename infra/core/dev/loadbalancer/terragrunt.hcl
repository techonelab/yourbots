include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "import", "terragrunt-info"]
  mock_outputs = {
    vpc_id               = "vpc-00000000000000000"
    public_subnet_ids    = ["subnet-public-1", "subnet-public-2"]
    private_subnet_ids   = ["subnet-private-1", "subnet-private-2"]
  }
}

locals{
  root_config_path = find_in_parent_folders("root.hcl")
  parent_config = read_terragrunt_config(local.root_config_path)
}

dependency "security_groups" {
  config_path = "../securitygroups"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "import", "terragrunt-info"]
  mock_outputs = {
    public_alb_sg_id  = "sg-public-alb"
    private_alb_sg_id = "sg-private-alb"
  }
}

terraform {
  source = "../../../../modules/loadbalancer"
}

inputs = {
  vpc_id               = dependency.vpc.outputs.vpc_id
  public_subnet_ids    = dependency.vpc.outputs.public_subnet_ids
  private_subnet_ids   = dependency.vpc.outputs.private_subnet_ids
  public_alb_sg_id     = dependency.security_groups.outputs.public_alb_sg_id
  private_alb_sg_id    = dependency.security_groups.outputs.private_alb_sg_id
  prefix               = local.parent_config.locals.project_name
  tags                 = local.parent_config.locals.common_tags
}