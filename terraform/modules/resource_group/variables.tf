variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}