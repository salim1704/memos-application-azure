resource "azurerm_container_app_environment" "main" {
  name                       = "${var.prefix}-environment"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = var.workspace_id
  zone_redundancy_enabled    = true
  infrastructure_subnet_id   = var.container_apps_subnet_id
  tags                       = var.tags

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_container_app" "memos" {
  name                         = "${var.prefix}-container-app"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  dynamic "registry" {
    for_each = var.image_tag != "" ? [1] : []
    content {
      server   = var.login_server
      identity = var.identity_id
    }
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "memos-container"
      image  = var.image_tag != "" ? "${var.login_server}/memos:${var.image_tag}" : "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "MEMOS_DRIVER"
        value = "postgres"
      }

      env {
        name  = "MEMOS_DSN"
        value = "postgres://${var.admin_username}:${var.db_password}@${var.db_fqdn}:5432/${var.database_name}"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8081
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }
}