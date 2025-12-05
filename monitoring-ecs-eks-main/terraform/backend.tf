terraform {
  backend "s3" {
    bucket         = "terraform-bucket-ap"
    key            = "path/to/my/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    use_lockfile   = true
  }
}
