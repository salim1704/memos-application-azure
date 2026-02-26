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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}


variable "db_password" {
  description = "Password for the PostgreSQL administrator"
  type        = string
  sensitive   = true
}

variable "virtual_network_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "postgresql_subnet_id" {
  description = "ID of the PostgreSQL subnet"
  type        = string
}

variable "admin_username" {
  description = "Username for the PostgreSQL administrator"
  type        = string
}