# data "terraform_remote_state" "vpc" {
#   backend = "s3"
#   config = {
#     bucket  = "device-suppression-postback"
#     key     = "terraform/base/terraform.tfstate"
#     region  = "us-east-1"
#   }
# }

# this is changed for getting public subnets
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "device-suppression-postback"
    key     = "terraform/development/vpc/us-east-01/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket  = "device-suppression-postback"
    key     = "terraform/development/security_groups/terraform.tfstate"
    region  = "us-east-1"
  }
}