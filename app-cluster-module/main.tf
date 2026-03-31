terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
  }
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "~> 7.0"

  resource_group_name = var.resource_group_name
  location            = var.location
  prefix              = "${var.app_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  vnet_subnet_id      = var.subnet_id

  net_profile_service_cidr   = "172.16.0.0/16"
  net_profile_dns_service_ip = "172.16.0.10"

  agents_count        = var.node_count
  agents_size         = "Standard_D2s_v3"
  agents_min_count    = 1
  agents_max_count    = var.node_count * 2
  enable_auto_scaling = true

  # Security defaults — not exposed to app devs
  private_cluster_enabled           = true
  role_based_access_control_enabled = true
  rbac_aad                          = true
  rbac_aad_managed                  = true
  network_plugin                    = "azure"
  network_policy                    = "azure"
  os_disk_size_gb                   = 50

  tags = {
    app_name    = var.app_name
    environment = var.environment
    managed_by  = "pulumi"
  }
}
