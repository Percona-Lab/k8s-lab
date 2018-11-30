output "vpc_self_link" {
  value = "${google_compute_network.compute_network.self_link}"
}

output "vpc_id" {
  value = "${google_compute_network.compute_network.id}"
}

output "vpc_gateway_ipv4" {
  value = "${google_compute_network.compute_network.gateway_ipv4}"
}

output "vpc_routing_mode" {
  value = "${google_compute_network.compute_network.routing_mode}"
}
