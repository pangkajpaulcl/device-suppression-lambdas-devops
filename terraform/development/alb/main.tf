provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    key    = "terraform/staging/alb/terraform.tfstate"
    bucket = "device-suppression-postback" # Don't change
    region = "us-east-1"
    dynamodb_table = "DeviceSuppressionTerraformStateLock_production" # TODO: Parameterize account label suffix
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
  required_version = "~> 1.1.0"
}

module "global" {
  source = "../../modules/staging-global"
}
