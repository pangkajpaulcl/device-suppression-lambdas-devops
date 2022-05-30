resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  #tags = merge(var.tags, { Name = "${var.name}"})
  tags = merge(var.tags, { Name = var.name})

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}
