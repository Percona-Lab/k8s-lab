variable "k8s_cluster_name" {
  description = "Kubeernetes cluster name"
}

variable "k8s_service_account" {
  description = "Service account to manage Kubernetes cluster"
  default     = "default"
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
