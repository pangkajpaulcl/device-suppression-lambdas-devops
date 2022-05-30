output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb-internal-development.target_group_arns
}

output "alb_dns_name"{
  description = "Application load balancer dns name"
  value = module.alb-internal-development.lb_dns_name
}

output "alb_dns_postback_address"{
  description = "Application load balancer dns name"
  value = "${module.alb-internal-development.lb_dns_name}/postback"
}
