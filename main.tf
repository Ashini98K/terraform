# Example code 01

# Evething inside curly braces are called blocks (have a name and identifiers)
# This is a resource block
# Identifier : aws_instance (indicates that we are going to create an aws instance) which comes from AWS provider
# Second identifier : test_instance (then name we use witihin our teffaform code)
# resource "aws_instance" "test_instance" {
#   # Arguments
#   ami = "ami-0f7098256151"
#   instance_type = "t2.nano"

#   tags = {
#     Name = "test server"
#   }
# }

# Example code 02

# This is a terraform block 
# It defines the definotion of the project and requiremnts needed
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
  # backend "s3" {
  #   bucket = "value"
  #   key    = "value"
  #   region = "value"
  # }
}

# Configure the AWS Provider
# Tells terraform where we are going to deploy our code
provider "aws" {
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

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
  bucket = "aws_s3_bucket.terraform-backend-15039819-a.id"

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = "aws_s3_bucket.terraform-backend-15039819-a.id"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

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
  # count         = 4 #(this will create 4 instances)
  # Here is the logic to create 0 instances if the workspace is backend workspace else for other it will create 1 instance
  count         = terraform.workspace == "backend" ? 0 : 1
  ami           = "ami-0e9878fc797487093"
  instance_type = "t2.nano"

  tags = {
    Name = "Test Server"
  }
}
