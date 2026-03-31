terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_storage_account" "this" {
  # Storage account names must be lowercase, 3-24 chars, no hyphens
  name                     = substr(replace("${var.app_name}${var.environment}docs", "-", ""), 0, 24)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"

  # Security defaults — locked in
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = var.versioning_enabled

    delete_retention_policy {
      days = var.environment == "prod" ? 30 : 7
    }

    container_delete_retention_policy {
      days = var.environment == "prod" ? 30 : 7
    }
  }

  tags = {
    app_name    = var.app_name
    environment = var.environment
    managed_by  = "pulumi"
  }
}

resource "azurerm_storage_container" "documents" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}