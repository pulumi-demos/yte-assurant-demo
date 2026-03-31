output "cluster_name"     { value = module.aks.aks_name }
output "cluster_id"       { value = module.aks.aks_id }
output "kubeconfig_command" {
  value = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${module.aks.aks_name}"
}