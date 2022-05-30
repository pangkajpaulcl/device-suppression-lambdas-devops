variable "name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  #type        = map(string)
  #default     = {}
}

variable "create_timeout" {
  description = "Time to wait for a security group to be created"
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Time to wait for a security group to be deleted"
  type        = string
  default     = "15m"
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself"
  type        = bool
  default     = false
}

variable "sg_rules_cidr" {
  type        = list
  description = "List of maps with security group rules where cidr_blocks is defined, supports ipv4 CIDRs only"
  default     = []
}

variable "sg_rules_sg" {
  type        = list
  description = "List of maps with security group rules where another sg is defined"
  default     = []
}

variable "sg_rules_self" {
  type        = list
  description = "List of maps with security group rules where 'self' is defined"
  default     = []
}
