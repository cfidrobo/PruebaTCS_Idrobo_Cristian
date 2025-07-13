terraform {
  backend "gcs" {
    bucket = "tf-state-cfidrobo"
    prefix = "devops-assessment"
  }
}
