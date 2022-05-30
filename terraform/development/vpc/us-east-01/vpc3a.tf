module "dev-vpc3a" {
  source                   = "../../../modules/vpc"
  vpc_prefix               = "vpc3a"
  vpc_suffix               = "dev"
  cidr                     = "10.6.0.0/16"
  enable_dns_hostnames     = true
  enable_dns_support       = true
  devops_subnets           = ["10.6.0.0/22"]
  data_subnets             = ["10.6.4.0/22","10.6.36.0/22","10.6.68.0/22"]
  app_subnets              = ["10.6.8.0/22","10.6.40.0/22","10.6.72.0/22"] 
  public_subnets           = ["10.6.12.0/22","10.6.44.0/22","10.6.76.0/22"]
  vpn_subnets              = ["10.6.20.0/22","10.6.52.0/22","10.6.84.0/22"]
  azs                      = ["us-east-1a","us-east-1b","us-east-1c"]
  assign_public_ip         = "true"

  # These are the AWS Tags that every item should have.
  tags = module.global.tags
}
