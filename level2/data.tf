data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "aws-terraform-state-romdhan"
    key    = "leve1.tfstate"
    region = "us-east-1"
  }
}
