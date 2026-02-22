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
  address_prefixes    = var.address_prefixes
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
  tags                     = var.tags
  depends_on               = [module.resource_group, module.monitoring, module.vnet, module.identity]
}

module "front_door" {
  source              = "./modules/front_door"
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  container_app_fqdn  = module.container_app.container_app_fqdn
  tags                = var.tags
  depends_on          = [module.resource_group, module.container_app]
}