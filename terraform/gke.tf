resource "google_container_cluster" "devops" {
  name                     = "devops-cluster"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary" {
  name       = "primary-pool"
  cluster    = google_container_cluster.devops.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type   = "e2-medium"
    disk_type      = "pd-standard"   
    disk_size_gb   = 30              
    oauth_scopes   = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_address" "lb_ip" {
  name   = "devops-lb-ip"
  region = var.region
}
