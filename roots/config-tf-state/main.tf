provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  #token = "${var.aws_session_token}"
}

# S3 Bucket for the Terraform state
resource "aws_s3_bucket" "s3-tf-state" {
  bucket        = "ges-tf-state"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "${var.name_tag_prefix}-ges-state-s3"
  }
}

# Dynamodb Table for Terraform state lock
resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
   name = "terraform-lock"
   hash_key = "LockID"
   read_capacity = 20
   write_capacity = 20

   attribute {
      name = "LockID"
      type = "S"
   }

   tags {
     Name = "Terraform Lock Table"
   }
}