data "azurerm_client_config" "current" {}

resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault" "main" {
  name                       = "${var.prefix}-kv"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"
  tags                       = var.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "Set", "Delete", "List", "Purge", "Recover"]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.principal_id

    secret_permissions = ["Get", "List"]
  }
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "${var.prefix}-db-password"
  value        = random_password.db.result
  key_vault_id = azurerm_key_vault.main.id
}