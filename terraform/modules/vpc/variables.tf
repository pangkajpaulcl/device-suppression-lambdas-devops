variable "vpc_prefix" {
    description = "VPC prefix name to use for naming convention"
}

variable "vpc_suffix" {
    description = "VPC suffix name to user for naming convention"
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "0.0.0.0/0"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "tags" {
  description = "A dictionary of AWS Tags"
}

variable "devops_subnets" {
  description = "A list of devops subnets inside the VPC"
  default     = []
}

variable "data_subnets" {
  description = "A list of data subnets inside the VPC"
  default     = []
}

variable "app_subnets" {
  description = "A list of app subnets inside the VPC"
  default     = []
}

variable "public_firewall_subnets" {
  description = "A list of public firewall subnets inside the VPC"
  default     = []
}

variable "private_firewall_subnets" {
  description = "A list of private firewall subnets inside the VPC"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "vpn_subnets" {
  description = "A list of vpn client subnets inside the VPC"
  default     = []
}

variable "assign_public_ip" {
  default = "true"
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}
