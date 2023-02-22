terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-romdhan"
    key            = "level2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-terraform-state-romdhan"

  }
}
