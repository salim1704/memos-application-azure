module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "vnet" {
  source              = "./modules/vnet"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_address_space  = var.vnet_address_space
  app_address_prefixes    = var.app_address_prefixes
  postgresql_address_prefixes = var.postgresql_address_prefixes
  tags                = var.tags
  depends_on          = [module.resource_group]
}

module "monitoring" {
  source              = "./modules/monitoring"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  depends_on          = [module.resource_group]
}

module "acr" {
  source              = "./modules/acr"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  depends_on          = [module.resource_group]
}

module "identity" {
  source              = "./modules/identity"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  acr_id              = module.acr.acr_id
  tags                = var.tags
  depends_on          = [module.resource_group, module.acr]
}

module "container_app" {
  source                   = "./modules/container_app"
  prefix                   = var.prefix
  location                 = var.location
  resource_group_name      = var.resource_group_name
  workspace_id             = module.monitoring.workspace_id
  container_apps_subnet_id = module.vnet.container_apps_subnet_id
  login_server             = module.acr.login_server
  identity_id              = module.identity.identity_id
  image_tag                = var.image_tag
  admin_username = var.admin_username
  db_password       = module.key_vault.db_password
  db_fqdn        = module.postgresql.db_fqdn
  database_name  = module.postgresql.database_name
  tags                     = var.tags
 depends_on = [module.resource_group, module.monitoring, module.vnet, module.identity, module.postgresql, module.key_vault]
}

module "front_door" {
  source              = "./modules/front_door"
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  container_app_fqdn  = module.container_app.container_app_fqdn
  domain_name         = var.domain_name
  tags                = var.tags
  depends_on          = [module.resource_group, module.container_app]
}

module "grafana" {
  source              = "./modules/grafana"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  subscription_id     = var.subscription_id
  admin_object_id     = var.admin_object_id
  tags                = var.tags
  depends_on          = [module.resource_group, module.monitoring]
}

module "key_vault" {
  source              = "./modules/key_vault"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  principal_id        = module.identity.principal_id
  tags                = var.tags
  depends_on          = [module.resource_group]
}

module "postgresql" {
  source              = "./modules/postgresql"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_network_id  = module.vnet.azurerm_virtual_network_id
  postgresql_subnet_id = module.vnet.postgresql_subnet_id
  admin_username      = var.admin_username
  db_password            = module.key_vault.db_password
  tags                = var.tags
  depends_on          = [module.resource_group, module.vnet]
}