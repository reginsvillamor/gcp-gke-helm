module "gke_cluster" {
  source       = "./modules/gke"
  env          = var.env
  project_id   = var.project_id
  project_name = var.project_name
}

output "lb_ip_for_gke_cluster" {
  value = module.gke_cluster.reserved_lb_static_ip
}
