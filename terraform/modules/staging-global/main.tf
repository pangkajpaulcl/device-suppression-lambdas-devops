variable "environment" {
  default = "staging"
}

variable "key_name" {
  default = "devops-2022-05-24"
}

variable "tags" {
  type = map
  default = {
    Environment = "staging"
    Terraform   = "True"
  }
}