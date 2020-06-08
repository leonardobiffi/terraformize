provider "aws" {
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    bucket  = "terraform-tf-vikings"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_iam_user" "main" {
  name = var.username
}

variable "username" {
  type = string
  description = "Username to Create IAM User"
}

output "iam_user" {
  value = aws_iam_user.main.name
}
