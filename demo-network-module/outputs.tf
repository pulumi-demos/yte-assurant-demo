output "resource_group_name"    { value = azurerm_resource_group.this.name }
output "location"               { value = azurerm_resource_group.this.location }
output "vnet_id"                { value = azurerm_virtual_network.this.id }
output "aks_subnet_id"          { value = azurerm_subnet.aks.id }
output "postgresql_subnet_id"   { value = azurerm_subnet.postgresql.id }
output "postgresql_dns_zone_id" { value = azurerm_private_dns_zone.postgresql.id }