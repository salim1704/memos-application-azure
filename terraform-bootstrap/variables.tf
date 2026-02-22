variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "uksouth"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}