output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "devops_subnets" {
  description = "List of IDs of devops subnets"
  value       = aws_subnet.devops.*.id
}

output "data_subnets" {
  description = "List of IDs of data subnets"
  value       = aws_subnet.data.*.id
}

output "app_subnets" {
  description = "List of IDs of app subnets"
  value       = aws_subnet.app.*.id
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public.*.id
}

output "vpn_subnets" {
  description = "List of IDs of vpn client subnets"
  value       = aws_subnet.vpn.*.id
}