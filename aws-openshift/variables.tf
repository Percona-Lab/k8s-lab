//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the cluster into"
  default = "us-east-1"
}

//  The public key to use for SSH access.
variable "public_key_path" {
  default = "~/.ssh/id_rsa_percona.pub"
}

//  This map defines which AZ to put the 'Public Subnet' in, based on the
//  region defined. You will typically not need to change this unless
//  you are running in a new region!
variable "subnetaz" {
  type = "map"

  default = {
    us-east-1 = "us-east-1d"
    us-east-2 = "us-east-2a"
    us-west-1 = "us-west-1a"
    us-west-2 = "us-west-2a"
    eu-west-1 = "eu-west-1a"
    eu-west-2 = "eu-west-2a"
    eu-central-1 = "eu-central-1a"
    ap-southeast-1 = "ap-southeast-1a"
  }
}
