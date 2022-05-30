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
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_arn.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create SQS queue | `bool` | `true` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level | `string` | `null` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes) | `number` | `0` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Boolean designating a FIFO queue | `bool` | `false` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group | `string` | `null` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `number` | `300` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB) | `number` | `262144` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days) | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | This is the human-readable name of the queue. If omitted, Terraform will assign a random name. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A unique name beginning with the specified prefix. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The JSON policy for the SQS queue | `string` | `""` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds) | `number` | `0` | no |
| <a name="input_redrive_allow_policy"></a> [redrive\_allow\_policy](#input\_redrive\_allow\_policy) | The JSON policy to set up the Dead Letter Queue redrive permission, see AWS docs. | `string` | `""` | no |
| <a name="input_redrive_policy"></a> [redrive\_policy](#input\_redrive\_policy) | The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5") | `string` | `""` | no |
| <a name="input_sqs_managed_sse_enabled"></a> [sqs\_managed\_sse\_enabled](#input\_sqs\_managed\_sse\_enabled) | Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | The ARN of the SQS queue |
<!-- END_TF_DOCS -->

# AWS SQS Terraform module

Terraform module which creates SQS resources on AWS.

## Usage
```hcl
module "engage-example-prod" {
  source  = "../../modules/sqs"

  name = "engage-example-prod"

  tags = module.global.tags
}
```

## Examples
### 1. Simple queue with no Access Policy and no encryption
```hcl
module "engage-example-prod" {
  source  = "../../modules/sqs"

  name = "engage-example-prod"

  tags = module.global.tags
}
```
### 2. Simple queue with SSE-SQS encryption
```hcl
module "engage-example-prod" {
  source  = "../../modules/sqs"

  name                    = "engage-example-prod"
  sqs_managed_sse_enabled = true

  tags = module.global.tags
}
```
### 3. Simple queue with SSE-KMS encryption
```hcl
module "engage-example-prod" {
  source  = "../../modules/sqs"

  name                              = "engage-example-prod"
  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300

  tags = module.global.tags
}
```
### 4. Simple queue with Access policy
```hcl
module "engage-example-prod" {
  source  = "../../modules/sqs"

  name = "engage-example-prod"

  policy = <<POLICY
    {
      "Id": "Policy1651119688768",
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "RestrictToEngageApp",
          "Action": [
            "sqs:ChangeMessageVisibility",
            "sqs:DeleteMessage",
            "sqs:ReceiveMessage",
            "sqs:SendMessage"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:sqs:us-east-1:237634799245:EngageFills-production",
          "Principal": {
            "AWS": [
              "arn:aws:iam::237634799245:role/engageNetworkAppRole"
            ]
          }
        }
      ]
    }
  POLICY

  tags = module.global.tags
}
```
### 5. FIFO queue
```hcl
module "engage-example-prod-fifo" {
  source  = "../../modules/sqs"

  name                        = "engage-example-prod.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"

  tags = module.global.tags
}
```
### 6. Dead Letter Queues (DLQ)
```hcl
module "engage-example-prod-dlq" {
  source = "../../modules/sqs"

  name = "engage-example-prod-dlq"

  sqs_managed_sse_enabled = true

  policy = <<POLICY
    {
      "Version": "2008-10-17",
      "Id": "__default_policy_ID",
      "Statement": [
        {
          "Sid": "__owner_statement",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::237634799245:root"
          },
          "Action": "SQS:*",
          "Resource": "arn:aws:sqs:us-east-1:237634799245:full_story_delete_staging"
        }
      ]
    }
  POLICY
}

module "engage-example-prod" {
  source = "../../modules/sqs"

  name = "engage-example-prod"

  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = module.engage-example-prod-dlq.sqs_queue_arn,
    maxReceiveCount  = 10
  })
}
```