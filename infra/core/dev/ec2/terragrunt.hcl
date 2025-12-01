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
  source = "../../../../modules/ec2"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "import", "terragrunt-info"]
  mock_outputs = {
    public_subnet_ids    = ["subnet-public-1", "subnet-public-2"]
    private_subnet_ids   = ["subnet-private-1", "subnet-private-2"]
  }
}

dependency "securitygroups" {
  config_path = "../securitygroups"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "import", "terragrunt-info"]
  mock_outputs = {
    public_ec2_sg_id  = "sg-ec2-public"
    private_ec2_sg_id = "sg-ec2-private"
  }
}

dependency "iamroles" {
  config_path = "../iamroles"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "import", "terragrunt-info"]
  mock_outputs = {
    instance_profile_name = "mock-ssm-profile"
  }
}

inputs = {
  public_subnet_ids       = dependency.vpc.outputs.public_subnet_ids
  private_subnet_ids      = dependency.vpc.outputs.private_subnet_ids
  # for testing purpose we are using this for now
  public_sg_id            = dependency.securitygroups.outputs.public_alb_sg_id
  private_sg_id           = dependency.securitygroups.outputs.private_alb_sg_id 
  ssm_instance_profile_name = dependency.iamroles.outputs.ssm_role
  # create this manually
  key_pair_name           = "<your-key-pair>"
  environment = "${local.environment}"
  tags = merge(local.parent_config.locals.common_tags, {

  })
}