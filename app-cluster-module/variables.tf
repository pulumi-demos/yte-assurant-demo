variable "app_name" {
  type        = string
  description = "Name of the application (e.g. claims-processing)"
}
variable "environment" {
  type        = string
  description = "Deployment environment: dev, staging, or prod"
}
variable "resource_group_name" {
  type        = string
  description = "Azure resource group provisioned by the platform team"
}
variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}
variable "subnet_id" {
  type        = string
  description = "Subnet ID from the network team for AKS nodes"
}
variable "node_count" {
  type        = number
  default     = 2
  description = "Number of worker nodes"
}
variable "kubernetes_version" {
  type    = string
  default = "1.34"
}
