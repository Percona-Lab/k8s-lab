resource "google_compute_network" "compute_network" {
  name                    = "${var.vpc_name}-vpc"
  routing_mode            = "${var.vpc_routing_mode}"
  auto_create_subnetworks = "true"
}
