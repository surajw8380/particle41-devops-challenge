terraform {
  backend "s3" {
    bucket         = "simpletime-terraform-state-bucket"
    key            = "ecs/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "simpletime-terraform-locks"
    encrypt        = true
  }
}
