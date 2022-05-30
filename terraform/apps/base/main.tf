#
# Main entry point for the Base infrastructure needed for Fargate services.
# These are common objects, declared ONLY here, that don't change.
#

provider "aws" {
  region = "us-east-1"
}

locals {
  docker_repo_url = "237634799245.dkr.ecr.us-east-1.amazonaws.com"
}

output "base_outputs" {
  value = {
    # ecs_task_execution_role                   = aws_iam_role.ecs_task_exec_role
    # cron_ecs_task_execution_role              = aws_iam_role.cron_ecs_task_exec_role
    # kinesis_ecs_task_execution_role           = aws_iam_role.kinesis_ecs_task_exec_role
    # sqs_survey_answer_ecs_task_execution_role = aws_iam_role.sqs_survey_answer_ecs_task_exec_role
    main_vpc                                  = data.aws_vpc.main_vpc
    private_subnets                           = aws_subnet.private_subnets
    # docker_repo_url                           = local.docker_repo_url
    # datadog_api_key                           = "80bdbb99a937b6137d6afcf456629eff"
    # datadog_image_url                         = "${local.docker_repo_url}/devops/inmo-datadog:latest"

  }
}

terraform {
  backend "s3" {
    key    = "terraform/base/terraform.tfstate"
    bucket = "device-suppression-postback" # Don't change
    region = "us-east-1"
    dynamodb_table = "DeviceSuppressionTerraformStateLock_production" # TODO: Parameterize account label suffix
  }
}

# resource "aws_s3_bucket" "state_bucket" {
#   bucket = "device-suppression-postback"
#   acl    = "private"

#   versioning {
#     enabled = true
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }

data "aws_vpc" "main_vpc" {
  cidr_block = "10.6.0.0/16"
  tags = {
    Name        = "vpc3a-dev-vpc"
    Environment = "development"
    Terraform   = "True"
  }
}
