# this role defined specially for lambda function
resource "aws_iam_role" "lambda_firehsoe_s3_role" {
  name = "lambda_firehsoe_s3_role_${var.environment}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })


}

# creating s3 bucket policiy
resource "aws_iam_policy" "policy" {
  name        = "lambda-s3-policy-${var.environment}"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleStmt",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        },
        {
           "Effect": "Allow",
           "Action": [
               "lambda:InvokeFunction",
               "lambda:GetFunctionConfiguration"
           ],
           "Resource": [
               "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.kinesis_processor_lambda_function_name}:$LATEST"
           ]
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.kinesis_processor_lambda_function_name}:*",
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.adid_postbacks_lambda_function_name}:*",
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.sqs_lambda_function_name}:*"
            ]
        }
    ]
}
EOF
}


# attach s3 policy to lambda role
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.lambda_firehsoe_s3_role.name
  policy_arn = aws_iam_policy.policy.arn
  depends_on = [aws_iam_policy.policy]
}

# attach sqs default policy to lambda role
resource "aws_iam_role_policy_attachment" "sqs_execution_role" {
  role       = aws_iam_role.lambda_firehsoe_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# attach firehose default policy to lambda role
resource "aws_iam_role_policy_attachment" "kinesis_firehos_execution_role" {
  role       = aws_iam_role.lambda_firehsoe_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
}

# attach default cloudwach policy to lambda role
resource "aws_iam_role_policy_attachment" "cloudwatch_execution_role" {
  role       = aws_iam_role.lambda_firehsoe_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# create firehose role for creating a firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose_execution_role_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "s3_attach_firehose" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.policy.arn
  depends_on = [aws_iam_policy.policy]
}


