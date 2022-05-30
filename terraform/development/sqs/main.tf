provider "aws" {
  region = "us-east-1"
  #profile = "development"
}

terraform {
  backend "s3" {
    key    = "terraform/development/sqs/terraform.tfstate"
    bucket = "device-suppression-postback" #"im-devops" # Don't change
    region = "us-east-1"
    #dynamodb_table = "DevopsTerraformStateLock_production" # TODO: Parameterize account label suffix
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
  source = "../../modules/dev-global"
}
