provider "kubernetes" {
  host                   = "https://${google_container_cluster.devops.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.devops.master_auth.0.cluster_ca_certificate
  )
}

resource "kubernetes_deployment" "app" {
  metadata {
    name   = "devops-service"
    labels = { app = "devops-service" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "devops-service" }
    }

    template {
      metadata {
        labels = { app = "devops-service" }
      }

      spec {
     
        image_pull_secrets {
          name = "ghcr-secret"
        }

        container {
          name  = "devops-service"
          image = "ghcr.io/cfidrobo/pruebatcs_idrobo_cristian:latest"     
          
          port {
            container_port = 3000
          }

          
          env_from {
            config_map_ref {
              name = "devops-config"
            }
          }
          env_from {
            secret_ref {
              name = "devops-secrets"
            }
          }

          
          readiness_probe {
            tcp_socket {
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          
          liveness_probe {
            tcp_socket {
              port = 3000
            }
            initial_delay_seconds = 15
            period_seconds        = 20
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "lb" {
  metadata {
    name = "devops-service-svc"
  }

  spec {
    selector = {
      app = kubernetes_deployment.app.spec[0].template[0].metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
