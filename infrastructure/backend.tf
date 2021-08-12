terraform {
  backend "s3" {
    bucket = "vapenation-astroneer-server"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
