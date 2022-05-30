provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    key    = "terraform/production/dynamodb/us-east-1/terraform.tfstate"
    bucket = "device-suppression-postback" # Don't change
    region = "us-east-1"
    # DO NOT USE LOCK TABLE HERE
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
  source = "../../../modules/global"
}
