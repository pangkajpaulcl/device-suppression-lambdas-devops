<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.log_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kinesis_firehose_delivery_stream.stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_config"></a> [cloudwatch\_config](#input\_cloudwatch\_config) | Map of all values for log delivery to CloudWatch Log Group. | `any` | `{}` | no |
| <a name="input_create_cloudwatch"></a> [create\_cloudwatch](#input\_create\_cloudwatch) | Switch for creating default Cloudwatch Log Group and Log Stream. | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Specifies should role be created with module or will there be external one provided. | `bool` | `true` | no |
| <a name="input_destination_type"></a> [destination\_type](#input\_destination\_type) | Type of destination for the Stream. | `string` | `"extended_s3"` | no |
| <a name="input_enable_cloudwatch_logging"></a> [enable\_cloudwatch\_logging](#input\_enable\_cloudwatch\_logging) | Switch for enabling log delivery to CloudWatch Log Group. | `bool` | `false` | no |
| <a name="input_enable_processing"></a> [enable\_processing](#input\_enable\_processing) | Switch for enabling processing via Lambda Function. | `bool` | `false` | no |
| <a name="input_enable_s3_backup"></a> [enable\_s3\_backup](#input\_enable\_s3\_backup) | Switch for enabling S3 backup cappability. | `bool` | `false` | no |
| <a name="input_enable_sse"></a> [enable\_sse](#input\_enable\_sse) | Switch for enabling Server Side Encryption. | `bool` | `true` | no |
| <a name="input_extended_s3_config"></a> [extended\_s3\_config](#input\_extended\_s3\_config) | Map of all values for extended s3 destination configuration. | `any` | `{}` | no |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | List of additional managed policies. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Kinesis Firehose Stream | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | List of additional policies for Firehose Stream access. | `list(any)` | `[]` | no |
| <a name="input_processing_lambda_arn"></a> [processing\_lambda\_arn](#input\_processing\_lambda\_arn) | Qualified ARN of Lambda Function that will do data processing before writing results to destination. | `string` | `""` | no |
| <a name="input_role"></a> [role](#input\_role) | Custom role ARN used for Firehoste Stream. | `string` | `""` | no |
| <a name="input_s3_backup_configuration"></a> [s3\_backup\_configuration](#input\_s3\_backup\_configuration) | Map of all values for S3 backup configuration, mostly same options as for extended\_s3\_config. | `any` | `{}` | no |
| <a name="input_sse_kms_key"></a> [sse\_kms\_key](#input\_sse\_kms\_key) | ARN of Customer Manager KMS key used for encryption. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
<!-- END_TF_DOCS -->

## Variable definitions

### name
Name for Kinesis Firehose. Also used in naming connected resources.
```hcl
name = "<name of Kinesis Firehose>"
```

### create_role
Specifies if IAM role for the Kinesis Firehose will be created in module or externally.
`true` - created with module
`false` - created externally
```hcl
create_role = <true or false>
````

Default:
```hcl
create_role = true
```

### policy
Additional inline policy statements for Kinesis Firehose role.
Effective only if `create_role` is set to `true`.
```hcl
policy = [<list of inline policies>]
```

Default:
```hcl
policy = []
```

### managed_policies
Additional managed policies which should be attached to auto-created role.
Effective only if `create_role` is set to `true`.
```hcl
managed_policies = [<list of managed policies>]
```

Default:
```hcl
managed_policies = []
```

### role
ARN of externally created role. Use in case of `create_role` is set to `false`.
```hcl
role = "<role ARN>"
```

Default:
```hcl
role = ""
```

### destination_type
Currently module has support only for `extended_s3` but can be upgraded and some components can be reused (s3 backup config, cloudwatch settings, role, processing block).
```hcl
destination_type = "<extended_s3, redshift, elasticsearch, splunk or http_endpoint>"
```

Default:
```hcl
destination_type = "extended_s3"
```

### enable_sse
Switch for enabling Server Side Encryption.
By default set to true and uses AWS Managed KMS key, custom one can be specified with `sse_kms_key`.
```hcl
enable_sse = <true or false>
```

Default:
```hcl
enable_sse = true
```

### sse_kms_key
ARN of Customer Manager KMS key used for encryption.
Valid only if `enable_sse` is `true`.
If ommited delivery streams data will be encrypted by AWS managed KMS key.
```hcl
sse_kms_key = "<ARN of KMS key>"
```

Default:
```hcl
sse_kms_key = ""
```

### enable_cloudwatch_logging
Switch for enabling log delivery to CloudWatch Log Group.
If set to `true` at least one of `create_cloudwatch` or `cloudwatch_config` have to be set.
```hcl
enable_cloudwatch_logging = <true or false>
```

Default:
```hcl
enable_cloudwatch_logging = false
```

### create_cloudwatch
Switch for creating default CloudWatch Log Group and Log Stream.
Defaults to `true`
```hcl
create_cloudwatch = <true or false>
```

Default:
```hcl
create_cloudwatch = false
```

### cloudwatch_config
Map of all values required for configuring delivery of logs to CloudWatch Logs.
```hcl
cloudwatch_config = {
  enabled         = <true or false>,
  log_group_name  = "<CloudWatch Log Group name>",
  log_stream_name = "<CloudWatch Log Group Stream name>"
}
```

Default:
```hcl
cloudwatch_config = {}
```

### extended_s3_config
Map of all values for extended s3 destination configuration.
```hcl
extended_s3_config = {
  bucket_arn         = "<ARN of destination s3 bucket>",
  prefix             = "<prefix in destination s3 bucket for delivery>",
  buffer_size        = <buffer size in MB>,
  buffer_interval    = <number of seconds before data is delivered, must be at least 60>,
  compression_format = "<UNCOMPRESSED, GZIP, ZIP, Snappy or HADOOP_SNAPPY>",
  kms_key_arn        = "<KMS key ARN for encryption on S3 bucket>"
}
```

Default:
```hcl
extended_s3_config = {}
```

### enable_s3_backup
Switch for enabling S3 backup cappability.
```hcl
enable_s3_backup = <true or false>
```

Default:
```hcl
enable_s3_backup = false
```

### s3_backup_configuration
Map of all values for S3 backup configuration, mostly same options as for extended_s3_config.
```hcl
s3_backup_configuration = {
  bucket_arn         = "<ARN of destination s3 bucket>",
  prefix             = "<prefix in destination s3 bucket for delivery>",
  buffer_size        = <buffer size in MB>,
  buffer_interval    = <number of seconds before data is delivered, must be a minimum of 60>,
  compression_format = "<UNCOMPRESSED, GZIP, ZIP, Snappy or HADOOP_SNAPPY>",
  kms_key_arn        = "<KMS key ARN for encryption on S3 bucket>"
}
```

Default:
```hcl
s3_backup_configuration = {}
```

### enable_processing
Switch for enabling processing via Lambda Function.
```hcl
enable_processing = <true or false>
```

Default:
```hcl
enable_processing = false
```

### processing_lambda_arn
Qualified ARN of Lambda Function that will do data processing before writing results to destination.
```hcl
processing_lambda_arn = "<Qualified ARN of Lambda Function>"
```

Default:
```hcl
processing_lambda_arn = ""
```

## Examples
### 1. Creates IAM role and CloudWatch Log Group
```hcl
module "foo" {
  source = "../../modules/kinesis-firehose"

  name = "foo"

  create_role = true

  create_cloudwatch         = true
  enable_cloudwatch_logging = true

  extended_s3_config = {
    bucket_arn         = "arn:aws:s3:::foo-test-bucket",
    prefix             = "firehose_data/",
    buffer_size        = 5,
    buffer_interval    = 60,
    compression_format = "UNCOMPRESSED"
  }

  tags = module.global.tags
}
```

### 2. Reference existing IAM role and existing CloudWatch Log Group
```hcl
module "foo" {
  source = "../../modules/kinesis-firehose"

  name = "foo"

  create_role = false
  role        = "arn:aws:iam::781568077634:role/AWSKinesisFirehoseRole-foo"

  create_cloudwatch         = false
  enable_cloudwatch_logging = true

  extended_s3_config = {
    bucket_arn         = "arn:aws:s3:::foo-test-bucket",
    prefix             = "firehose_data/",
    buffer_size        = 5,
    buffer_interval    = 60,
    compression_format = "UNCOMPRESSED"
  }

  cloudwatch_config = {
    enabled         = true,
    log_group_name  = "aws-firehose-logs-foo",
    log_stream_name = "S3Delivery"
  }

  tags = module.global.tags
}
```

### 3. Enable Processing using Lambda
```hcl
module "foo" {
  source = "../../modules/kinesis-firehose"

  name = "foo"

  create_role = true

  create_cloudwatch         = true
  enable_cloudwatch_logging = true

  extended_s3_config = {
    bucket_arn         = "arn:aws:s3:::foo-test-bucket",
    prefix             = "firehose_data/",
    buffer_size        = 5,
    buffer_interval    = 60,
    compression_format = "UNCOMPRESSED"
  }

  enable_processing     = true
  processing_lambda_arn = "arn:aws:lambda:us-east-1:781568077634:function:test-v2-vpc-config-lr-admin-vpc-test"

  tags = module.global.tags
}
```