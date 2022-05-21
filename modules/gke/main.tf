variable "env" {}

variable "project_id" {}

variable "project_name" {}

variable "region" {
  default = "asia-southeast1"
}

variable "zone" {
  default = "asia-southeast1-b"
}

variable "gke_master_version" {
  default = "1.20.15-gke.3400"
}

variable "gke_node_version" {
  default = "1.20.15-gke.3400"
}

variable "machine_type" {
  default = "g1-small"
}

variable "cluster_ipv4_cidr_block" {
  default = "10.10.0.0/16"
}

variable "services_ipv4_cidr_block" {
  default = "10.11.0.0/16"
}

variable "subnet_ip_cidr_range" {
  default = "10.35.0.0/24"
}

variable "node_count" {
  type    = number
  default = 1
}

resource "google_container_cluster" "primary" {
  name               = "${var.project_name}-${var.env}-${var.region}"
  project            = var.project_id
  location           = var.zone
  min_master_version = var.gke_master_version
  node_version       = var.gke_node_version

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool - preemptible
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-np-1"
  project    = var.project_id
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count
  version    = var.gke_node_version

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "${var.project_name}-${var.region}"
    }

    preemptible  = true
    machine_type = var.machine_type
    tags         = ["gke-node", "${var.project_name}-${var.region}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# Separately Managed Node Pool - non-preemptible
resource "google_container_node_pool" "primary_nodes_2" {
  name       = "${google_container_cluster.primary.name}-np-2"
  project    = var.project_id
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count
  version    = var.gke_node_version

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "${var.project_name}-${var.region}"
    }

    machine_type = var.machine_type
    tags         = ["gke-node", "${var.project_name}-${var.region}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# # Firewall Settings
# resource "google_compute_firewall" "${var.project_name}-gke" {
#   name    = "${var.project_name}-${var.region}-gke-ssh-rule"
#   network = google_compute_network.vpc.name
#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
#   target_tags   = ["gke-node", "${var.project_name}-${var.region}-gke"]
#   source_ranges = ["0.0.0.0/0"]
# }
