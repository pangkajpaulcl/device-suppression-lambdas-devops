output "vpc3a_id" {
  value = module.dev-vpc3a.vpc_id
}

output "vpc3a-devops-subnets" {
  value = module.dev-vpc3a.devops_subnets
}

output "vpc3a-data-subnets" {
  value = module.dev-vpc3a.data_subnets
}

output "vpc3a-app-subnets" {
  value = module.dev-vpc3a.app_subnets
}

output "vpc3a-public-subnets" {
  value = module.dev-vpc3a.public_subnets
}

output "vpc3a-vpn-subnets" {
  value = module.dev-vpc3a.vpn_subnets
}