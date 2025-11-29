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
  source = "../../../../modules/iamroles"
}

inputs = {
  environment = "${local.environment}"
  tags = merge(local.parent_config.locals.common_tags, {

  })
}