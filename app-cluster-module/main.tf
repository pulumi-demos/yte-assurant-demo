terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                    = "${var.app_name}-${var.environment}-aks"
  resource_group_name     = var.resource_group_name
  location                = var.location
  dns_prefix              = "${var.app_name}-${var.environment}"
  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = true

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_D2s_v3"
    vnet_subnet_id      = var.subnet_id
    os_disk_size_gb     = 50
    enable_auto_scaling = true
    min_count           = 1
    max_count           = var.node_count * 2
    node_count          = var.node_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }

  tags = {
    app_name    = var.app_name
    environment = var.environment
    managed_by  = "pulumi"
  }
}