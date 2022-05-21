
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  version          = "4.1.1"
  namespace        = "ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.loadBalancerIP"
    value = module.gke_cluster.reserved_lb_static_ip
  }
}
