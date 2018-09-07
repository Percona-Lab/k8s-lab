variable "cluster-name" {
  description = "Uniq cloud name"
  default     = "eks-pxc"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of ssh keypair"
  default     = "mykola"
}

data "aws_ami" "worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon Account ID
}
