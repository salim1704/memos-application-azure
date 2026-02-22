resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "${var.prefix}-fd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "${var.prefix}-fd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                     = "${var.prefix}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {}

  health_probe {
    path                = "/healthz"
    request_type        = "GET"
    protocol            = "Https"
    interval_in_seconds = 60
  }
}

resource "azurerm_cdn_frontdoor_origin" "main" {
  name                          = "${var.prefix}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id

  enabled                        = true
  host_name                      = var.container_app_fqdn
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.container_app_fqdn
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "main" {
  name                     = "${var.prefix}-custom-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  host_name                = "tm.abdulqayoom.co.uk"

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_route" "main" {
  name                          = "${var.prefix}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.main.id]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.main.id]

  supported_protocols    = ["Https", "Http"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  link_to_default_domain = true
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "main" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.main.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.main.id]
}

# DNS — Route53

data "aws_route53_zone" "main" {
  name = "abdulqayoom.co.uk"
}

resource "aws_route53_record" "memos" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "tm"
  type    = "CNAME"
  ttl     = 300
  records = [azurerm_cdn_frontdoor_endpoint.main.host_name]
}

resource "aws_route53_record" "validation" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "_dnsauth.tm.abdulqayoom.co.uk"
  type    = "TXT"
  ttl     = 300
  records = [azurerm_cdn_frontdoor_custom_domain.main.validation_token]
}