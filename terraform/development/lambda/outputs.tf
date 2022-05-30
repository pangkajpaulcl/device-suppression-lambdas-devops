output "lambda_function_names" {
  value = {
    adid_postbacks = aws_lambda_function.adid_postbacks.arn,
    adid_postbacks_unattributed = aws_lambda_function.adid_postbacks_unattributed.arn
    adid_postbacks_attributed = aws_lambda_function.adid_postbacks_attributed.arn
    }
    description = "List of all lambdas function"

}


data "aws_caller_identity" "current" {}


output "account_id" {
  value = data.aws_caller_identity.current.account_id
}