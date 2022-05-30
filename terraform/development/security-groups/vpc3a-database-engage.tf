module "vpc3a-database-engage" {
  source = "../../modules/security_groups"

  name        = "vpc3a-vpn-egress"
  description = "VPN egress policy"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc3a_id
  
  # These are the AWS Tags that every item should have.
  tags = module.global.tags

  sg_rules_cidr = [
    {
      type     = "egress",
      desc     = ""
      from     = 0,
      to       = 0,
      protocol = "-1",
      cidr     = "10.6.0.0/16"
    }
  ]
}

module "vpc3a-outside-access" {
  source = "../../modules/security_groups"

  name        = "vpc3a-public-ingress"
  description = "Public ingress policy"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc3a_id
  
  # These are the AWS Tags that every item should have.
  tags = module.global.tags

  sg_rules_cidr = [
    {
      type     = "ingress",
      desc     = ""
      from     = 0,
      to       = 0,
      protocol = "-1",
      cidr     = "0.0.0.0/0"
    },{
      type     = "egress",
      desc     = ""
      from     = 0,
      to       = 0,
      protocol = "-1",
      cidr     = "0.0.0.0/0"
    }
  ]
}