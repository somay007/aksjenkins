provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rgasp" {
  location = var.location
  name = var.resource_group_name
}


resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rgasp.name
  location            = azurerm_resource_group.rgasp.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rgasp.location
  resource_group_name = azurerm_resource_group.rgasp.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"

  }
  tags = {
    Environment = "Development"
  }
  

}

# Attach AKS to ACR
resource "azurerm_role_assignment" "acr_attach" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

//Outputs
output "resource_group_name" {
  value = azurerm_resource_group.rgasp.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
