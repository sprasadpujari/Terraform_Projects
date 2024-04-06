
terraform {
  backend "s3" {
    bucket = "s3statebackend2020"
    dynamodb_table = "terraform-up-and-running-locks"
    key = "global/mystatefile/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true

}
}
provider "aws" {
  region = var.region
  secret_key = "************************"
  access_key = "************************"
}

