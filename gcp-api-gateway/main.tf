terraform {
  required_version = ">= 1.6"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.8.0"
    }
  }
}

variable "project_id" {
  type    = string
  default = "orders-lab-placeholder"
}

provider "google-beta" {
  project = var.project_id
  region  = "europe-west1"
}

resource "google_api_gateway_api" "orders" {
  provider = google-beta
  api_id   = "orders-api"
}

resource "google_api_gateway_api_config" "v1" {
  provider      = google-beta
  api           = google_api_gateway_api.orders.api_id
  api_config_id = "orders-config-v1"

  openapi_documents {
    document {
      path     = "openapi.yaml"
      contents = filebase64("${path.module}/openapi.yaml")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "orders" {
  provider   = google-beta
  api_config = google_api_gateway_api_config.v1.id
  gateway_id = "orders-gateway"
}
