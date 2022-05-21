variable "env" {}

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
