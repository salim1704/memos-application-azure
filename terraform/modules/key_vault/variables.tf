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

variable "principal_id" {
  description = "Principal ID of the managed identity"
  type        = string
}