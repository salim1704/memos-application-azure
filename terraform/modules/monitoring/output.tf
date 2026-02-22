output "workspace_id" {
  description = "Resource ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "primary_shared_key" {
  value = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive = true
}

