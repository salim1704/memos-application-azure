output "db_password" {
  value = azurerm_key_vault_secret.db_password.value
  sensitive = true
}

output "key_vault_id" {
  value = azurerm_key_vault.main.id
}