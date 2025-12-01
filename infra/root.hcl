remote_state {
  backend = "s3"
  config = {
    bucket         = "<name-of-your-bucket>"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}
EOF
}

locals {
  env_map = {
    "prd" = "production"
    "stg" = "staging"
    "qa"  = "qa"
    "dev" = "development"
  }
  project_name = "executive-bot"
  region = "us-east-1"
  azs             = ["us-east-1a", "us-east-1b"]
  common_tags = {
    Project     = local.project_name
    ManagedBy   = "Terragrunt"
  }
}

