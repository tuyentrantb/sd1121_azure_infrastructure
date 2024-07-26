resource "azurerm_role_assignment" "acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                          = "${var.resource_prefix}acr"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = "Standard"
  admin_enabled                 = true
  public_network_access_enabled = true

  tags = module.label.tags
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                 = "${var.resource_prefix}-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  dns_prefix           = var.resource_prefix
  azure_policy_enabled = true

  default_node_pool {
    name                = "system"
    node_count          = 1
    vm_size             = "Standard_D2plds_v5"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  tags = module.label.tags
}

resource "kubernetes_namespace" "aks_namespace" {
  metadata {
    name = var.aks_namespace
  }
}