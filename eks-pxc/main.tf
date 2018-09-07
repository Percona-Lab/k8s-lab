provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "percona-tmp"
    key    = "terraform/eks-pxc.tfstate"
    region = "us-west-2"
  }
}
