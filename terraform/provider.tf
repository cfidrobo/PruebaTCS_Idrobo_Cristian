provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.credentials
}

data "google_client_config" "current" {}
