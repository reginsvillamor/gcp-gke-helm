module "gke_cluster" {
  source       = "./modules/gke"
  env          = "staging"
  project_id = var.project_id
  project_name = var.project_name
}

output "proxy_another_client_domain_name" {
  value = module.gke_cluster.gke_static_ip
}
