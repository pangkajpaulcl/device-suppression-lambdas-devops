
variable "environment" {
  type    = string
  description = "Select an environment [dev/staging/prod]: "
  default = "dev"
}

variable "region" {
  type    = string
  description = "Select a region [us-east-1]: "
  default = "us-east-1"
}

variable "adid_postbacks_lambda_function_name" {
  default = "receive_query_from_alb"
}

variable "kinesis_processor_lambda_function_name" {
  default = "device_suppression_kinesis_processor"
}

variable "sqs_lambda_function_name" {
  default = "device_suppression_sqs_main"
}

variable "bucket_name" {
  type    = string
  default = "im-devops"
}



