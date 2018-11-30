# Basic GCP VPC

This module allow to create basic VPC network with all regions as subnets.

## Resources

- [google_compute_network](https://www.terraform.io/docs/providers/google/r/compute_network.html)

## Variables

```HCL
variable "vpc_name" {
  description = "Unique name identifier for vpc"
}
variable "vpc_routing_mode" {
  description = "GCP network-wide routing mode for Cloud Routers"
  default     = "REGIONAL"
}
```

## Outputs
```HCL
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
```