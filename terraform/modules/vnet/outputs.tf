output "azurerm_virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "container_apps_subnet_id" {
  value = azurerm_subnet.container_apps_subnet.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.main.id
}

output "container_apps_subnet_cidr" {
  description = "CIDR block of the Container Apps subnet"
  value       = azurerm_subnet.container_apps_subnet.address_prefixes[0]
}

output "postgresql_subnet_id" {
  description = "ID of the PostgreSQL subnet"
  value       = azurerm_subnet.postgresql_subnet.id
}