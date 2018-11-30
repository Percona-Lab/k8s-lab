variable "k8s_name" {
  description = "Kubeernetes cluster name"
}

variable "k8s_description" {
  description = "Kubernetes cluster description"
  default     = ""
}

variable "k8s_main_zone" {
  description = "Main zone in which nodes will be created"
}

variable "k8s_additional_zones" {
  description = "Additional zones in which nodes will be created"
  type        = "list"
}

variable "k8s_initial_node_count" {
  description = "Initial node count for cluster"
  default     = "1"
}

variable "k8s_node_machine_type" {
  description = "Kubernetes node machine type"
  default     = "n1-standard-1"
}

variable "k8s_node_preemptible" {
  description = "Turn cluster nodes to preemptible mode"
  default     = "false"
}

variable "k8s_min_master_version" {
  description = "Minimal version of Kubernetes master"
}

variable "k8s_enable_alpha" {
  description = "Enable Kubernetes Alpha features. !!! If enable cluster will be automaticly terminated in 30 days !!!"
  default     = "false"
}

variable "k8s_node_disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB"
  default     = "100"
}

variable "k8s_local_ssd_count" {
  description = "The amount of local SSD disks that will be attached to each cluster node"
  default     = "0"
}

variable "k8s_vpc_network_self_link_or_name" {
  description = "Self_link of the Google Compute Engine network to which the cluster is connected"
  default     = "default"
}

variable "k8s_enable_legacy_abac" {
  description = "Enable Kubernetes legacy ABAC"
  default     = "false"
}

variable "k8s_monitoring_service" {
  default     = "monitoring.googleapis.com"
  description = "The monitoring service that the cluster should write metrics to. Available options monitoring.googleapis.com and none"
}

variable "k8s_logging_service" {
  default     = "logging.googleapis.com"
  description = "Logging service that the cluster should write logs to. Available options logging.googleapis.com and none"
}

variable "k8s_master_username" {
  description = "Kubernetes cluster admin username"
}

variable "k8s_master_password" {
  description = "Kubernetes cluster admin password"
}

variable "k8s_node_oauth_scopes" {
  type        = "list"
  description = "List of Google API scopes to be made available on all of the node VMs"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/trace.append",
  ]
}

variable "k8s_disable_horizontal_pod_autoscaling" {
  description = "Disable horizontal pod autoscaling"
  default     = "false"
}

variable "k8s_disable_http_load_balancing" {
  description = "Disable HTTP (L7) load balancing controller"
  default     = "false"
}

variable "k8s_disable_kubernetes_dashboard" {
  description = "Disable Kubernetes Dashboard"
  default     = "false"
}

variable "k8s_disable_network_policy_config" {
  description = "Disable network policy"
  default     = "true"
}

variable "k8s_enable_network_policy" {
  description = "A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints"
  default     = "false"
}

variable "k8s_network_policy_provider" {
  description = "Network policy provider"
  default     = "PROVIDER_UNSPECIFIED"
}

variable "k8s_service_account" {
  description = "Service account to manage Kubernetes cluster"
  default     = "default"
}

variable "k8s_maintenance_time" {
  description = "Time window specified for daily maintenance operations"
  default     = "03:00"
}

variable "k8s_labels" {
  type        = "list"
  description = "List of Map's with labels for k8s cluster"
  default     = []
}

variable "k8s_pool_name" {
  description = "Name for the pool"
  default     = "node-pool"
}

variable "k8s_pool_min_node_count" {
  description = "Minimum numbers of nodes at node pool for cluster"
  default     = "1"
}

variable "k8s_pool_max_node_count" {
  description = "Maximum numbers of nodes at node pool for cluster"
  default     = "1"
}

variable "k8s_pool_initial_node_count" {
  description = "Initial node count for node pool"
  default     = "1"
}

variable "k8s_pool_node_machine_type" {
  description = "Kubernetes pool node machine type"
  default     = "n1-standard-1"
}

variable "k8s_pool_node_preemptible" {
  description = "Turn cluster pool nodes to preemptible mode"
  default     = "false"
}

variable "k8s_pool_node_disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB"
  default     = "100"
}

variable "k8s_pool_local_ssd_count" {
  description = "The amount of local SSD disks that will be attached to each cluster node"
  default     = "0"
}

variable "k8s_pool_node_zone" {
  description = "Zone for pool nodes"
}