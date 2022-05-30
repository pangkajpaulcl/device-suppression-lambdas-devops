output "vpc3a_database_engage_security_group_id" {
  description = "The ID of the security group"
  value       = module.vpc3a-database-engage.security_group_id
}
output "vpc3a_outside_access_security_group_id" {
  description = "The ID of the security group"
  value       = module.vpc3a-outside-access.security_group_id
}
