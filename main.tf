terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "delegate_ns" {
  metadata {
    name = "harness-delegate-ng"
  }
}

module "delegate" {
  source  = "harness/harness-delegate/kubernetes"
  version = "0.1.8"

  account_id        = var.harness_account_id
  delegate_token    = var.delegate_token
  delegate_name     = "terraform-delegate"
  deploy_mode       = "KUBERNETES"
  namespace         = kubernetes_namespace.delegate_ns.metadata[0].name
  manager_endpoint  = "https://app.harness.io"
  delegate_image    = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.04.85602"
  replicas          = 1
  upgrader_enabled  = true
}
