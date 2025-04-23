provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "delegate" {
  source          = "harness/harness-delegate/kubernetes"
  version         = "0.1.8"

  account_id      = "ucHySz2jQKKWQweZdXyCog"
  delegate_token  = "NTRhYTY0Mjg3NThkNjBiNjMzNzhjOGQyNjEwOTQyZjY="
  delegate_name   = "terraform-delegate"
  deploy_mode     = "KUBERNETES"
  namespace       = "harness-delegate-ng"
  manager_endpoint = "https://app.harness.io"
  delegate_image  = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.04.85602"
  replicas        = 1
  upgrader_enabled = true
}
