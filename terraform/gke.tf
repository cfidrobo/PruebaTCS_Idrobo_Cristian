resource "google_container_cluster" "devops" {
  name               = "devops-cluster"
  location           = var.region
  remove_default_node_pool = true
}

resource "google_container_node_pool" "primary" {
  name       = "primary-pool"
  cluster    = google_container_cluster.devops.name
  location   = var.region
  node_count = 2
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
