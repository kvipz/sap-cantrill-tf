resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-06072024"
}

resource "aws_dynamodb_table" "tf_state" {
  hash_key       = "LockID"
  name           = "tf-state-lock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}