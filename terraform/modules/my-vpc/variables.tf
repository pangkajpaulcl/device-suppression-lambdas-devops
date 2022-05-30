
variable "vpc_cidr" {
    default = "10.0.0.0/24"
}
variable "tenancy" {
     default = "default"
}
variable "vpc_id" {}

variable "subnet_cidrs" {
    description = "this is the subnet list"
    type = list(string)
    default = ["10.0.0.0/23","10.0.0.128/23"]
}

variable "availability_zones" {
    type = list(string)
    description = "The az that the resources will be launched"
    default = ["us-east-1a","ap-south-1b","ap-south-1c"]
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "development_environment" {
    type = string
}


variable "app_name" {
  type    = string
  description = "provide app name"
  default = "device-suppression"
} 