resource "google_compute_network" "vpc" {
  name                    = "${var.project_name}-${var.region}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.project_name}-${var.region}-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = var.subnet_ip_cidr_range
  private_ip_google_access = "true"

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 1
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_address" "static_ip" {
  name = "glb-${var.env}-${var.region}-ip"
}