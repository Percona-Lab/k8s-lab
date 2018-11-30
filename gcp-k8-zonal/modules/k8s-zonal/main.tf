resource "google_container_cluster" "k8s" {
  name        = "${var.k8s_name}"
  description = "${var.k8s_description}"

  zone = "${var.k8s_main_zone}"

  additional_zones = [
    "${var.k8s_additional_zones}",
  ]

  network = "${var.k8s_vpc_network_self_link_or_name}"

  initial_node_count = "${var.k8s_initial_node_count}"
  min_master_version = "${var.k8s_min_master_version}"

  master_auth {
    username = "${var.k8s_master_username}"
    password = "${var.k8s_master_password}"
  }

  node_config {
    machine_type    = "${var.k8s_node_machine_type}"
    preemptible     = "${var.k8s_node_preemptible}"
    disk_size_gb    = "${var.k8s_node_disk_size_gb}"
    local_ssd_count = "${var.k8s_local_ssd_count}"

    service_account = "${var.k8s_service_account}"

    oauth_scopes = [
      "${var.k8s_node_oauth_scopes}",
    ]

    labels = "${var.k8s_labels}"
  }

  network_policy {
    enabled  = "${var.k8s_enable_network_policy}"
    provider = "${var.k8s_network_policy_provider}"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "${var.k8s_maintenance_time}"
    }
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = "${var.k8s_disable_horizontal_pod_autoscaling}"
    }

    http_load_balancing {
      disabled = "${var.k8s_disable_http_load_balancing}"
    }

    kubernetes_dashboard {
      disabled = "${var.k8s_disable_kubernetes_dashboard}"
    }

    network_policy_config {
      disabled = "${var.k8s_disable_network_policy_config}"
    }
  }

  enable_kubernetes_alpha = "${var.k8s_enable_alpha}"
  enable_legacy_abac      = "${var.k8s_enable_legacy_abac}"

  monitoring_service = "${var.k8s_monitoring_service}"
  logging_service    = "${var.k8s_logging_service}"

  lifecycle {
    ignore_changes = [
      "labels",
    ]
  }
}

resource "google_container_node_pool" "np" {
  name    = "${var.k8s_name}-${var.k8s_pool_name}"
  zone    = "${var.k8s_pool_node_zone}"
  cluster = "${google_container_cluster.k8s.name}"

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
