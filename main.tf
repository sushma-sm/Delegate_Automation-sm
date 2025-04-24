provider "google" {
  project = "teak-surge-455704-t3"
  region  = "us-central1"
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}

# Create GCS bucket
resource "google_storage_bucket" "my_bucket" {
  name          = "my-general-bucket-sm1" # Must be globally unique
  location      = "US"
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  force_destroy = true
}

# Create GKE Cluster
resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster-sm1"
  location           = "us-central1"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  remove_default_node_pool = false
  networking_mode          = "VPC_NATIVE"
  enable_autopilot         = false
}
