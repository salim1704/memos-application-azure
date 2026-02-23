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

variable "admin_object_id" {
  description = "Object ID of the user or group to assign Grafana Admin role"
  type        = string 
}