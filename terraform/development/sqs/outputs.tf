output "vpc3a_test_arn" {
  description = "ARN of the SQS queue"
  value       = module.vpc3a-sqs.sqs_queue_arn
}