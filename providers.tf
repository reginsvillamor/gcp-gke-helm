# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = module.gke_cluster.name
  project  = module.gke_cluster.project
  location = module.gke_cluster.location
}

provider "helm" {
  kubernetes {
    token                  = data.google_client_config.provider.access_token
    host                   = data.google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}
