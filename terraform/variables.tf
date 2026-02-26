variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
}

variable "app_address_prefixes" {
  description = "Address prefixes for the app subnet"
  type        = list(string)
}

variable "postgresql_address_prefixes" {
  description = "Address prefixes for the postgresql subnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "image_tag" {
  description = "Tag of the container image to deploy"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Base domain name for DNS"
  type        = string
}

variable "admin_object_id" {
  description = "Object ID of the user or group to assign Grafana Admin role"
  type        = string 
}

variable "admin_username" {
  description = "Username for the PostgreSQL administrator"
  type        = string
}

variable "gh_actions_object_id" {
  description = "Object ID of the GitHub Actions service principal"
  type        = string
}