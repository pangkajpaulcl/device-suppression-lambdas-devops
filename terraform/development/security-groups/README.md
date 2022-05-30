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
| <a name="module_vpc3a-database-engage"></a> [vpc3a-database-engage](#module\_vpc3a-database-engage) | ../../modules/security_groups | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc3a_database_engage_security_group_id"></a> [vpc3a\_database\_engage\_security\_group\_id](#output\_vpc3a\_database\_engage\_security\_group\_id) | The ID of the security group |
<!-- END_TF_DOCS -->