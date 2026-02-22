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

variable "workspace_id" {
  description = "ID of the Log Analytics Workspace"
  type        = string
}

variable "container_apps_subnet_id" {
  description = "ID of the Container Apps subnet"
  type        = string
}

variable "login_server" {
  description = "Login server of the Azure Container Registry"
  type        = string
}
variable "identity_id" {
  description = "ID of the user-assigned identity"
  type        = string
}

variable "image_tag" {
  description = "Tag of the container image to deploy"
  type        = string
  default     = "latest"
}