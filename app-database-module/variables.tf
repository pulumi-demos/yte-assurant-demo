variable "app_name"           { type = string }
variable "environment"        { type = string }
variable "resource_group_name"{ type = string }
variable "location" {
  type    = string
  default = "eastus"
}
variable "delegated_subnet_id" {
  type        = string
  description = "Subnet delegated to PostgreSQL Flexible Server by the network team"
}
variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS zone for PostgreSQL — provisioned by the network team"
}
variable "sku_name" {
  type    = string
  default = "B_Standard_B2ms"
}
variable "storage_mb" {
  type    = number
  default = 32768
}
variable "postgresql_version" {
  type    = string
  default = "15"
}