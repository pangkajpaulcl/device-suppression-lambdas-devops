variable "environment" {
  default = "production"
}

variable "key_name" {
  default = "devops-2022-03-02"
}

variable "tags" {
  type = map
  default = {
    Environment = "production"
    Terraform   = "True"
  }
}