resource "azurerm_virtual_network_peering" "hub_ondo-p-use-app01-vnet" {
  name                      = "hub_ondo-p-use-app01-vnet"
  resource_group_name       = "ondo-p-use-hub-rg"
  virtual_network_name      = azurerm_virtual_network.ondo-p-use-hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.ondo-p-use-app01-vnet.id
}

resource "azurerm_virtual_network_peering" "ondo-p-use-app01-vnet_hub" {
  name                      = "ondo-p-use-app01-vnet_hub"
  resource_group_name       = "ondo-p-use-app01-rg"
  virtual_network_name      = azurerm_virtual_network.ondo-p-use-app01-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.ondo-p-use-hub-vnet.id
}

resource "azurerm_virtual_network_peering" "hub_ondo-d-use-app01-vnet" {
  name                      = "hub_ondo-d-use-app01-vnet"
  resource_group_name       = "ondo-p-use-hub-rg"
  virtual_network_name      = azurerm_virtual_network.ondo-p-use-hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.ondo-d-use-app01-vnet.id
}

resource "azurerm_virtual_network_peering" "ondo-d-use-app01-vnet_hub" {
  name                      = "ondo-d-use-app01-vnet_hub"
  resource_group_name       = "ondo-d-use-app01-rg"
  virtual_network_name      = azurerm_virtual_network.ondo-d-use-app01-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.ondo-p-use-hub-vnet.id
}

