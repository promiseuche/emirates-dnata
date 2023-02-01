data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

data "azurerm_key_vault" "ednatakv" {
  name                = "ednatakv"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "clientId" {
  name         = "clientId"
  key_vault_id = data.azurerm_key_vault.ednatakv.id
}

data "azurerm_key_vault_secret" "clientSecret" {
  name         = "clientSecret"
  key_vault_id = data.azurerm_key_vault.ednatakv.id
}

data "azurerm_key_vault_secret" "idrsa" {
  name         = "idrsa"
  key_vault_id = data.azurerm_key_vault.ednatakv.id
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "ednata" {
  location            = var.log_analytics_workspace_location
  name                = "${var.log_analytics_workspace_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "ednata" {
  location              = azurerm_log_analytics_workspace.ednata.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.ednata.name
  workspace_resource_id = azurerm_log_analytics_workspace.ednata.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_kubernetes_cluster" "ednatak8s" {
  location            = var.log_analytics_workspace_location
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.idrsa.value}"
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = "${data.azurerm_key_vault_secret.clientId.value}"
    client_secret = "${data.azurerm_key_vault_secret.clientSecret.value}"
  }
}