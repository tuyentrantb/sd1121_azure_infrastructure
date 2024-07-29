variable "project" {
  type    = string
  default = "practicaldevops"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_prefix" {
  type        = string
  default     = "btdevops"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  default     = "adminuser"
  description = "Username for VM"
}
variable "aks_namespace" {
  type    = string
  default = "btdevops"
}