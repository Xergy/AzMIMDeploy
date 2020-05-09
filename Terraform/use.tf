
resource "azurerm_resource_group" "ondo-p-use-hub-rg" {
    name = "ondo-p-use-hub-rg"
    location = "usgovvirginia"
}

resource "azurerm_virtual_network" "ondo-p-use-hub-vnet" {
    name                = "ondo-p-use-hub-vnet"
    address_space       = ["172.20.1.0/24"]
    location            = azurerm_resource_group.ondo-p-use-hub-rg.location
    resource_group_name = azurerm_resource_group.ondo-p-use-hub-rg.name
}

resource "azurerm_subnet" "ondo-p-use-hub-vnet_Subnet00-00" {
    name                 = "Subnet01-00"
    resource_group_name  = azurerm_resource_group.ondo-p-use-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-hub-vnet.name
    address_prefix       = "172.20.1.0/27"
}

resource "azurerm_subnet" "ondo-p-use-hub-vnet_Subnet02-32" {
    name                 = "Subnet02-32"
    resource_group_name  = azurerm_resource_group.ondo-p-use-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-hub-vnet.name
    address_prefix       = "172.20.1.32/27"
}

resource "azurerm_subnet" "ondo-p-use-hub-vnet_Subnet03-64" {
    name                 = "Subnet03-64"
    resource_group_name  = azurerm_resource_group.ondo-p-use-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-hub-vnet.name
    address_prefix       = "172.20.1.64/27"
}

resource "azurerm_subnet" "ondo-p-use-hub-vnet_Subnet04-96" {
    name                 = "Subnet04-96"
    resource_group_name  = azurerm_resource_group.ondo-p-use-hub-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-hub-vnet.name
    address_prefix       = "172.20.1.96/27"
}

resource "azurerm_resource_group" "ondo-p-use-app01-rg" {
    name = "ondo-p-use-app01-rg"
    location = "usgovvirginia"
}

resource "azurerm_virtual_network" "ondo-p-use-app01-vnet" {
    name                = "ondo-p-use-app01-vnet"
    address_space       = ["172.20.2.0/24"]
    location            = azurerm_resource_group.ondo-p-use-app01-rg.location
    resource_group_name = azurerm_resource_group.ondo-p-use-app01-rg.name
}

resource "azurerm_subnet" "ondo-p-use-app01-vnet_Subnet00-00" {
    name                 = "Subnet01-00"
    resource_group_name  = azurerm_resource_group.ondo-p-use-app01-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-app01-vnet.name
    address_prefix       = "172.20.2.0/27"
}

resource "azurerm_resource_group" "ondo-d-use-app01-rg" {
    name = "ondo-d-use-app01-rg"
    location = "usgovvirginia"
}

resource "azurerm_virtual_network" "ondo-d-use-app01-vnet" {
    name                = "ondo-d-use-app01-vnet"
    address_space       = ["172.20.3.0/24"]
    location            = azurerm_resource_group.ondo-d-use-app01-rg.location
    resource_group_name = azurerm_resource_group.ondo-d-use-app01-rg.name
}

resource "azurerm_subnet" "ondo-d-use-app01-vnet_Subnet00-00" {
    name                 = "Subnet01-00"
    resource_group_name  = azurerm_resource_group.ondo-d-use-app01-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-d-use-app01-vnet.name
    address_prefix       = "172.20.3.0/27"
}
