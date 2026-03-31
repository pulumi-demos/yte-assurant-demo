output "cluster_name" { value = azurerm_kubernetes_cluster.this.name }
output "cluster_id"   { value = azurerm_kubernetes_cluster.this.id }
output "kubeconfig_command" {
  value = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${azurerm_kubernetes_cluster.this.name}"
}