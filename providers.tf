variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1" # change if needed
}

provider "aws" {
  region = var.aws_region
}
