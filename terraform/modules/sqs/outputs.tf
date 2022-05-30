output "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value = element(
    concat(
      aws_sqs_queue.this.*.arn,
      [""],
    ),
    0,
  )
}