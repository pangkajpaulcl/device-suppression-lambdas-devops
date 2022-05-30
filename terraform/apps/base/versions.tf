terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.6" # Enforce max here, per docs
    }
  }
  required_version = "~> 1.1.0"
}
