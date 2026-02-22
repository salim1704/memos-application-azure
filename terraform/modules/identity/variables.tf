variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}

}
variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "acr_id" {
  description = "ID of the Azure Container Registry"
  type        = string
}
