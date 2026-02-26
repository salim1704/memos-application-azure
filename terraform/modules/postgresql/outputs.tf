output "server_id" {
  value = azurerm_postgresql_flexible_server.server.id
}

output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.server.fqdn
}

output "database_name" {
  description = "Name of the PostgreSQL database"
  value       = azurerm_postgresql_flexible_server_database.memosdb.name
}