output "id" {
  value = "${google_container_cluster.k8s.id}"
}

output "name" {
  value = "${google_container_cluster.k8s.name}"
}

output "endpoint" {
  value = "${google_container_cluster.k8s.endpoint}"
}

output "username" {
  value = "${google_container_cluster.k8s.master_auth.0.username}"
}

output "password" {
  value = "${google_container_cluster.k8s.master_auth.0.password}"
}

output "client_certificate" {
  value = "${google_container_cluster.k8s.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.k8s.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.k8s.master_auth.0.cluster_ca_certificate}"
}

output "instance_group_urls" {
  value = "${google_container_cluster.k8s.instance_group_urls}"
}
