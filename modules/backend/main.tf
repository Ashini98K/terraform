# Example code 03

# This is a terraform block 
# It defines the definotion of the project and requiremnts needed
# Everthing in the terraform block cannot pull anything within the infrastrucutre
terraform {
  # Sub block which defines the provider we are using
  # Tells terraform the dependencies that we a pulling in to the project
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Setting up a backend for terraform state
  # What used is s3 but there are more options like consul, etcd, gcs, etc
  backend "s3" {
    encrypt = true
    bucket  = "terraform-backend-15039819-a"
    key     = "terraform-state/terraform.tfstate"
    region  = "us-east-1"

    dynamodb_table = "terraform-state-lock-class"
  }
}

# Configure the AWS Provider
# Tells terraform where we are going to deploy our code
provider "aws" {
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

# S3 Bucket
resource "aws_s3_bucket" "terraform_backend" {
  bucket = "terraform-backend-15039819-a"
  lifecycle {
    prevent_destroy = false
  }
  force_destroy = true

  tags = {
    Name = "Terraform Backend"
  }
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.terraform_backend.id


  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

# DynamoDB Table
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock-class"

  # Id for the table
  hash_key       = "lockID"
  read_capacity  = 20
  write_capacity = 20

  # Schema  (below is a table with one colummn)
  attribute {
    name = "lockID"
    type = "S"
  }
  tags = {
    name = "DynamoDb that store the lock of the terraform"
  }
}

# EC2 Instance
resource "aws_instance" "test_instance" {
  # Arguments
  ami           = "ami-0e9878fc797487093"
  instance_type = "t2.nano"

  tags = {
    Name = "Test Server"
  }
}
