terraform {
  required_version = ">= 0.11.0"

  backend "gcs" {
    bucket  = "operators-tfstate"
    prefix  = "psmdb/test"
    project = "cloud-dev-112233"
  }
}

provider "google" {
  project     = "cloud-dev-112233"
  credentials = "${file("${var.creds_path}")}"
}

module "vpc" {
  source   = "./modules/vpc-multi-region"
  vpc_name = "psmdb"
}

module "k8s" {
  source          = "./modules/k8s-zonal"
  k8s_name        = "eu-psmdb"
  k8s_description = "psmdb EU k8s test cluster"

  k8s_min_master_version = "1.11.2-gke.18"
  k8s_master_username    = "${var.k8s_master_username}"
  k8s_master_password    = "${var.k8s_master_password}"
  k8s_main_zone          = "europe-west1-b"

  k8s_additional_zones = [
    "europe-west1-c",
    "europe-west1-d",
  ]

  k8s_vpc_network_self_link_or_name = "${module.vpc.vpc_self_link}"
  k8s_pool_node_zone                = "europe-west1-d"
}
