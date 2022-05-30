data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "device-suppression-postback"
    key     = "terraform/development/vpc/us-east-01/terraform.tfstate"
    region  = "us-east-1"
  }
}