terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-romdhan"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-terraform-state-romdhan"

  }
}
