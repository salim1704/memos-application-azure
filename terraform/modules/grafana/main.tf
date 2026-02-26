resource "azurerm_dashboard_grafana" "main" {
  name                              = "${var.prefix}-grafana"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  grafana_major_version             = 11
  api_key_enabled                   = false
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true
  sku                               = "basic"
  tags                              = var.tags

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "grafana_admin" {
  scope                = azurerm_dashboard_grafana.main.id
  role_definition_name = "Grafana Admin"
  principal_id         = var.admin_object_id
}