
# Used by Terraform, specified at:
#   https://www.terraform.io/language/settings/backends/s3#dynamodb-state-locking
#
# NOTE: Here the "_production" suffix implies the production *account*. This
#       table should cover locking for all Terraform objects managed in the
#       "IM Production" account.
#
resource "aws_dynamodb_table" "DevopsTerraformStateLock_production" {
  name           = "DeviceSuppressionTerraformStateLock_production"
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }

  # These are the AWS Tags that every item should have.
  tags = module.global.tags
}
