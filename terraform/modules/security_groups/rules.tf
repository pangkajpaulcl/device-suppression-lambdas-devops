resource "aws_security_group_rule" "sg-rule-cidr" {
  count             = length(var.sg_rules_cidr)
  type              = lookup(var.sg_rules_cidr[count.index], "type", null)
  description       = lookup(var.sg_rules_cidr[count.index], "desc", null)
  from_port         = lookup(var.sg_rules_cidr[count.index], "from", null)
  to_port           = lookup(var.sg_rules_cidr[count.index], "to", null)
  protocol          = lookup(var.sg_rules_cidr[count.index], "protocol", null)
  cidr_blocks       = [lookup(var.sg_rules_cidr[count.index], "cidr", null)]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "sg-rule-sg" {
  count                    = length(var.sg_rules_sg)
  type                     = lookup(var.sg_rules_sg[count.index], "type", null)
  description              = lookup(var.sg_rules_sg[count.index], "desc", null)
  from_port                = lookup(var.sg_rules_sg[count.index], "from", null)
  to_port                  = lookup(var.sg_rules_sg[count.index], "to", null)
  protocol                 = lookup(var.sg_rules_sg[count.index], "protocol", null)
  source_security_group_id = lookup(var.sg_rules_sg[count.index], "source_security_group_id", null)
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "sg-rule-self" {
  count             = length(var.sg_rules_self)
  type              = lookup(var.sg_rules_self[count.index], "type", null)
  description       = lookup(var.sg_rules_self[count.index], "desc", null)
  from_port         = lookup(var.sg_rules_self[count.index], "from", null)
  to_port           = lookup(var.sg_rules_self[count.index], "to", null)
  protocol          = lookup(var.sg_rules_self[count.index], "protocol", null)
  self              = lookup(var.sg_rules_self[count.index], "self", null)
  security_group_id = aws_security_group.this.id
}