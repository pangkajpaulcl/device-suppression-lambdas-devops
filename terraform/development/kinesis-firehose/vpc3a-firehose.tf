module "kinesis_firehose" {
  source = "../../modules/kinesis-firehose"

  name = "device_suppression_dev_kinesis"

  create_role = true

  create_cloudwatch         = true
  enable_cloudwatch_logging = true

  extended_s3_config = {
    bucket_arn         = "arn:aws:s3:::device-suppression-postback",
    prefix             = "firehose_data/!{partitionKeyFromLambda:network_id}/"
    error_output_prefix = "firehose_error_data/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyyy}-!{timestamp:MM}-!{timestamp:dd}-!{timestamp:HH}/"
    buffer_size        = 64,
    buffer_interval    = 60,
    compression_format = "UNCOMPRESSED"
  }

     dynamic_partitioning_config = true
  

  enable_processing     = true
  processing_lambda_arn = "arn:aws:lambda:us-east-1:837630247226:function:development-v1-go-adid_postbacks_unattributed"

  tags = module.global.tags
}