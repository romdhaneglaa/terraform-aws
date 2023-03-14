data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "aws-terraform-state-romdhan"
    key    = "leve1.tfstate"
    region = "us-east-1"
  }
}
data "aws_secretsmanager_secret" "password" {
  name = "rds/password"
}
data "aws_secretsmanager_secret_version" "version" {
  secret_id = data.aws_secretsmanager_secret.password.id
}


