variable "agent_count" {
  default = 3
}

variable "aks_service_principal_app_id" {
  default = "$(clientId)"
}

variable "aks_service_principal_client_secret" {
  default = "$(clientSecret)"
}

variable "cluster_name" {
  default = "emiratesdnatak8s"
}

variable "dns_prefix" {
  default = "k8sedanata"
}

variable "log_analytics_workspace_location" {
  default = "eastus"
}

variable "log_analytics_workspace_name" {
  default = "emiratesDnataLogAnalyticsWorkspace"
}


variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "resource_group_name" {
  default     = "emirates-dnata"
  description = "Location of the resource group."
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "ssh_public_key" {
  default = "$(idrsa)"
}