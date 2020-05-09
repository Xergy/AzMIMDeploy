resource "azurerm_resource_group" "ondo-p-use-onprem-rg" {
    name = "ondo-p-use-onprem-rg"
    location = "usgovvirginia"
}

resource "azurerm_virtual_network" "ondo-p-use-onprem-vnet" {
    name                = "ondo-p-use-onprem-vnet"
    address_space       = ["172.22.1.0/24"]
    location            = azurerm_resource_group.ondo-p-use-onprem-rg.location
    resource_group_name = azurerm_resource_group.ondo-p-use-onprem-rg.name
}

resource "azurerm_subnet" "ondo-p-use-onprem-vnet_Subnet00-00" {
    name                 = "Subnet01-00"
    resource_group_name  = azurerm_resource_group.ondo-p-use-onprem-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-onprem-vnet.name
    address_prefix       = "172.22.1.0/27"
}

resource "azurerm_subnet" "ondo-p-use-onprem-vnet_Subnet02-32" {
    name                 = "Subnet02-32"
    resource_group_name  = azurerm_resource_group.ondo-p-use-onprem-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-onprem-vnet.name
    address_prefix       = "172.22.1.32/27"
}

resource "azurerm_subnet" "ondo-p-use-onprem-vnet_Subnet03-64" {
    name                 = "Subnet03-64"
    resource_group_name  = azurerm_resource_group.ondo-p-use-onprem-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-onprem-vnet.name
    address_prefix       = "172.22.1.64/27"
}

resource "azurerm_subnet" "ondo-p-use-onprem-vnet_Subnet04-96" {
    name                 = "Subnet04-96"
    resource_group_name  = azurerm_resource_group.ondo-p-use-onprem-rg.name
    virtual_network_name = azurerm_virtual_network.ondo-p-use-onprem-vnet.name
    address_prefix       = "172.22.1.96/27"
}
