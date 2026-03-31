terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "storage_account" {
  source  = "Azure/storage-account/azurerm"
  version = "~> 0.2"

  storage_account_name = replace("${var.app_name}${var.environment}docs", "-", "")
  resource_group_name  = var.resource_group_name
  location             = var.location

  # Versioning controlled by caller
  blob_versioning_enabled = var.versioning_enabled

  # Security defaults — locked in regardless of what caller passes
  account_tier              = "Standard"
  account_replication_type  = var.environment == "prod" ? "GRS" : "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  shared_access_key_enabled = false  # Force Azure AD auth only

  # No public blob access — ever
  allow_nested_items_to_be_public = false

  # Soft delete retention
  blob_delete_retention_policy = var.environment == "prod" ? 30 : 7
  container_delete_retention_policy = var.environment == "prod" ? 30 : 7

  tags = {
    app_name    = var.app_name
    environment = var.environment
    managed_by  = "pulumi"
  }
}