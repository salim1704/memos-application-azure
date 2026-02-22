output "app_id" {
  description = "ID of the container app"
  value       = azurerm_container_app.memos.id
}

output "latest_revision_fqdn" {
  description = "FQDN of the latest revision of the container app"
  value       = azurerm_container_app.memos.latest_revision_fqdn  
}

output "container_app_fqdn" {
  value = azurerm_container_app.memos.ingress[0].fqdn
}