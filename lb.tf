resource "google_compute_address" "lb_static_ip" {
  name = "lb-${var.env}-${var.region}-ip"
}
