resource "aws_s3_bucket" "aws_bucket" {
  bucket = "aws-terraform-state-romdhan"
}
resource "aws_dynamodb_table" "dynamo_db" {
  name           = "aws-terraform-state-romdhan"
  hash_key       = "LockID"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}

