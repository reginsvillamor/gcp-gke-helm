output "reserved_lb_static_ip" {
  value = google_compute_address.static_ip.address
}