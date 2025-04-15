variable "subscription_id" {
  description = "Subscription id of the account"
  type = string
  default = "2e35691f-5103-4cad-a61c-dbc64c14af55"
}

variable "location" {
    description = "location of service"
    type = string
    default = "eastus2"
}
variable "resource_group_name" {
  description = "resource group name"
  type = string
  default = "rg-aks"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry (must be globally unique)"
  type        = string
  default     = "acrregistry932409"
}

variable "acr_sku" {
  description = "SKU of the ACR"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Whether admin access is enabled for ACR"
  type        = bool
  default     = true
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aksclusterfordotnetviajenkins"
}


variable "aks_node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "aks_node_vm_size" {
  description = "Size of the VMs in the AKS node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

