provider "azurerm" {
    version = "=2.1.0"
    features {}
  }

resource "azurerm_resource_group" "ondo-p-usw-hub-rg" {
    name = "ondo-p-usw-hub-rg"
    location = "usgovarizona"
}

resource "azurerm_virtual_network" "ondo-p-usw-hub-vnet" {
    name                = "ondo-p-usw-hub-vnet"
    address_space       = ["172.21.1.0/24"]
    location            = azurerm_resource_group.ondo-p-usw-hub-rg.location
    resource_group_name = azurerm_resource_group.ondo-p-usw-hub-rg.name
}

resource "azurerm_subnet" "ondo-p-usw-hub-vnet_Subnet00-00" {
    name                 = "Subnet01-00"
    resource_group_name  = azurerm_resource_group.ondo-p-usw-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-usw-hub-vnet.name
    address_prefix       = "172.21.1.0/27"
}

resource "azurerm_subnet" "ondo-p-usw-hub-vnet_Subnet02-32" {
    name                 = "Subnet02-32"
    resource_group_name  = azurerm_resource_group.ondo-p-usw-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-usw-hub-vnet.name
    address_prefix       = "172.21.1.32/27"
}

resource "azurerm_subnet" "ondo-p-usw-hub-vnet_Subnet03-64" {
    name                 = "Subnet03-64"
    resource_group_name  = azurerm_resource_group.ondo-p-usw-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-usw-hub-vnet.name
    address_prefix       = "172.21.1.64/27"
}

resource "azurerm_subnet" "ondo-p-usw-hub-vnet_Subnet04-96" {
    name                 = "Subnet04-96"
    resource_group_name  = azurerm_resource_group.ondo-p-usw-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-usw-hub-vnet.name
    address_prefix       = "172.21.1.96/27"
}
