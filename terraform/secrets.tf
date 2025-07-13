resource "kubernetes_secret" "ghcr" {
  metadata {
    name      = "ghcr-secret"
    namespace = "default"
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    # aquí pones el contenido base64 de tu ~/.docker/config.json
    ".dockerconfigjson" = filebase64("${path.module}/dockerconfigjson")
  }
}
