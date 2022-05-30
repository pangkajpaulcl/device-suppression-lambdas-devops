<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_global"></a> [global](#module\_global) | ../../modules/dev-global | n/a |
| <a name="module_vpc3a-test"></a> [vpc3a-test](#module\_vpc3a-test) | ../../modules/sqs | n/a |
| <a name="module_vpc3a-test-dlq"></a> [vpc3a-test-dlq](#module\_vpc3a-test-dlq) | ../../modules/sqs | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.sqs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc3a_test_arn"></a> [vpc3a\_test\_arn](#output\_vpc3a\_test\_arn) | ARN of the SQS queue |
<!-- END_TF_DOCS -->