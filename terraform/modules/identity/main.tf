resource "azurerm_user_assigned_identity" "main" {
  location            = var.location
  name                = "${var.prefix}-identity"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Container App — pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
  principal_type       = "ServicePrincipal"
}