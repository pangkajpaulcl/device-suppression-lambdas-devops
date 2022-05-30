

# it will create lambda function zip file
data "archive_file" "adid_postbacks_archive" {
  type        = "zip"
  source_file = "${path.module}./../../lambdas/adid_postbacks/main"
  output_path = "${path.module}./../../lambdas/adid_postbacks/main.zip"
}

# create a lambda function from zip file
resource "aws_lambda_function" "adid_postbacks" {

  filename      = "${path.module}./../../lambdas/adid_postbacks/main.zip"
  function_name = "${var.adid_postbacks_lambda_function_name}"
  role          = aws_iam_role.lambda_firehsoe_s3_role.arn
  handler       = "main"

  source_code_hash = "${data.archive_file.adid_postbacks_archive.output_base64sha256}"

  runtime = "go1.x"

  environment {
    variables = {
      region = var.region
      kinesis_firehose_name = "device_suppression_dev_kinesis",
      sqs_name = "device_suppression_postbacks_development_sqs",
    }
  }

}


data "archive_file" "kinesis_lambda_processor" {
  type        = "zip"
  source_file = "${path.module}./../../lambdas/adid_postbacks_unattributed/main"
  output_path = "${path.module}./../../lambdas/adid_postbacks_unattributed/main.zip"
}

# this lambda function for receiving event from dead letter queue
resource "aws_lambda_function" "adid_postbacks_unattributed" {

  filename      = "${path.module}./../../lambdas/adid_postbacks_unattributed/main.zip"
  function_name = "${var.kinesis_processor_lambda_function_name}"
  role          = aws_iam_role.lambda_firehsoe_s3_role.arn
  handler       = "main"

  source_code_hash = "${data.archive_file.kinesis_lambda_processor.output_base64sha256}"


  runtime = "go1.x"


}


data "archive_file" "adid_postbacks_attributed_archive" {
  type        = "zip"
  source_file = "${path.module}./../../lambdas/adid_postbacks_attributed/main"
  output_path = "${path.module}./../../lambdas/adid_postbacks_attributed/main.zip"
}

# this lambda function for receiving event from dead letter queue
resource "aws_lambda_function" "adid_postbacks_attributed" {

  filename      = "${path.module}./../../lambdas/adid_postbacks_attributed/main.zip"
  function_name = "${var.sqs_lambda_function_name}"
  role          = aws_iam_role.lambda_firehsoe_s3_role.arn
  handler       = "main"

  source_code_hash = "${data.archive_file.adid_postbacks_attributed_archive.output_base64sha256}"


  runtime = "go1.x"


}



