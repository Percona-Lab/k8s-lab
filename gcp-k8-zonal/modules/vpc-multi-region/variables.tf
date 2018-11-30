variable "vpc_name" {
  description = "Unique name identifier for vpc"
}

variable "vpc_routing_mode" {
  description = "GCP network-wide routing mode for Cloud Routers"
  default     = "REGIONAL"
}
