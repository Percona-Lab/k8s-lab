resource "google_container_node_pool" "np" {
  name    = "${var.k8s_cluster_name}-${var.k8s_pool_name}"
  zone    = "${var.k8s_pool_node_zone}"
  cluster = "${var.k8s_cluster_name}"

  initial_node_count = "${var.k8s_pool_initial_node_count}"

  autoscaling {
    min_node_count = "${var.k8s_pool_min_node_count}"
    max_node_count = "${var.k8s_pool_max_node_count}"
  }

  node_config {
    machine_type    = "${var.k8s_pool_node_machine_type}"
    preemptible     = "${var.k8s_pool_node_preemptible}"
    disk_size_gb    = "${var.k8s_pool_node_disk_size_gb}"
    local_ssd_count = "${var.k8s_pool_local_ssd_count}"

    service_account = "${var.k8s_service_account}"

    oauth_scopes = [
      "${var.k8s_node_oauth_scopes}",
    ]

    labels = "${var.k8s_labels}"
  }

  lifecycle {
    ignore_changes = [
      "labels",
    ]
  }
}
