terraform {
  backend "s3" {
    bucket         = "prometheus-tf-state-liya07"
    key            = "prometheus/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"  # Remove this line if you skip DynamoDB
    encrypt        = true
  }
}
