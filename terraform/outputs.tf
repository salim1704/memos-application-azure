output "container_app_fqdn" {
  value = module.container_app.container_app_fqdn
}

output "front_door_endpoint" {
  value = module.front_door.front_door_endpoint_hostname
}
