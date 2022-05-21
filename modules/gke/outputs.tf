output "name" {
  value = google_container_cluster.primary.name
}

output "location" {
  value = google_container_cluster.primary.location
}

output "reserved_lb_static_ip" {
  value = google_compute_address.static_ip.address
}