variable "sqs_lambda_function_end"{
  default = "arn:aws:lambda:us-east-1:837630247226:function:development-v1-go-adid_postbacks_attributed"
  description = "provide sqs target lambda function arn"
}

module "vpc3a-sqs-dlq" {
  source = "../../modules/sqs"

  #name = "vpc3a-sqs-dlq"
  name = "device_suppression_postbacks_dlq_development"

  sqs_managed_sse_enabled = true
}

module "vpc3a-sqs" {
  source = "../../modules/sqs"

 # name = "vpc3a-sqs"
  name = "device_suppression_postbacks_development_sqs"

  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = module.vpc3a-sqs-dlq.sqs_queue_arn,
    maxReceiveCount  = 10
  })
}
  #policy = <<POLICY
  #  {
  #    "Version": "2008-10-17",
  #    "Id": "__default_policy_ID",
  #    "Statement": [
  #      {
  #        "Sid": "__owner_statement",
  #        "Effect": "Allow",
  #        "Principal": {
  #          "AWS": "arn:aws:iam::237634799245:root"
  #        },
  #        "Action": "SQS:*",
  #        "Resource": "arn:aws:sqs:us-east-1:237634799245:full_story_delete_staging"
  #      }
  #    ]
  #  }
  #POLICY
#}

resource "aws_lambda_event_source_mapping" "sqs_event" {
  event_source_arn = module.vpc3a-sqs.sqs_queue_arn
  function_name    = "${var.sqs_lambda_function_end}"
}
