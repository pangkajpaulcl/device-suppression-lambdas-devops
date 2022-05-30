

output "aws_lb_target_group_arn" {
    value = aws_lb_target_group.postback.arn
}

output "aws_lb_dns_name" {
    value = aws_lb.main.dns_name
}

output "load_balancer_name"{
  value = aws_lb.main.name
}
