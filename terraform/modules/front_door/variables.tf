variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}

}
variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}
variable "container_app_fqdn" {
  description = "Fully qualified domain name of the container app"
  type        = string
}