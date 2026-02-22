output "front_door_endpoint_hostname" {
  description = "Hostname of the Front Door endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
}