provider "kubernetes" {
  host                   = google_container_cluster.devops.endpoint
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.devops.master_auth[0].cluster_ca_certificate
  )
}

resource "kubernetes_deployment" "app" {
  metadata { name = "devops-service" }
  spec {
    replicas = 2
    selector { match_labels = { app = "devops-service" } }
    template {
      metadata { labels = { app = "devops-service" } }
      spec {
        container {
          name  = "devops-service"
          image = "ghcr.io/${var.project}/${path.basename(path.cwd)}:latest"
          port { container_port = 3000 }
        }
      }
    }
  }
}

resource "kubernetes_service" "lb" {
  metadata { name = "devops-service-svc" }
  spec {
    selector = { app = kubernetes_deployment.app.spec[0].template[0].metadata[0].labels.app }
    port { port = 80; target_port = 3000 }
    type = "LoadBalancer"
  }
}
