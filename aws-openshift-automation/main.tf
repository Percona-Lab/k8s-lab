//  Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
  version = "< 2.0"
}

// Save state file in S3
terraform {
 backend "s3" {
   encrypt = true
   region  = "us-west-2"
   bucket  = "terraform-state-storage-openshift"
   key = "terraform-automation.tfstate"
 }
}

//  Create the OpenShift cluster using our module.
module "openshift" {
  source          = "./modules/openshift"
  region          = "${var.region}"
  amisize         = "m5.xlarge"    //  Smallest that meets the min specs for OS
  vpc_cidr        = "10.0.0.0/16"
  subnet_cidr     = "10.0.1.0/24"
  key_name        = "openshift-jenkins"
  public_key_path = "${var.public_key_path}"
  cluster_name    = "jenkins-openshift-cluster"
  cluster_id      = "jenkins-openshift-cluster-${var.region}"
  rhel_password   = "${var.rhel_password}"
  rhel_user       = "${var.rhel_user}"
}

//  Output some useful variables for quick SSH access etc.
output "master-url" {
  value = "https://${module.openshift.master-public_ip}:8443"
}
output "master-public_ip" {
  value = "${module.openshift.master-public_ip}"
}
output "bastion-public_ip" {
  value = "${module.openshift.bastion-public_ip}"
}
