output "identity_id" {
  description = "ID of the user-assigned identity"
  value       = azurerm_user_assigned_identity.main.id
}

output "principal_id" {
  description = "Principal ID of the Managed Identity"
  value       = azurerm_user_assigned_identity.main.principal_id
}