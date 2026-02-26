resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "${var.prefix}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags    
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbvnetlink" {
  name                  = "${var.prefix}-db-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    =  var.virtual_network_id
  resource_group_name   =  var.resource_group_name
  tags                  =  var.tags
}


resource "azurerm_postgresql_flexible_server" "server" {
  name                          = "${var.prefix}-psql"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16"
  delegated_subnet_id           = var.postgresql_subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.dns_zone.id
  public_network_access_enabled = false
  administrator_login           = var.admin_username
  administrator_password        = var.db_password
  zone                          = "1"
  tags = var.tags

  storage_mb   = 32768
  storage_tier = "P4"

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.dbvnetlink]

}


resource "azurerm_postgresql_flexible_server_database" "memosdb" {
  name      = "${var.prefix}-memosdb"
  server_id = azurerm_postgresql_flexible_server.server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  lifecycle {
    #prevent_destroy = true
  }
}