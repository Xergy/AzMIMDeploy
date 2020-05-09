
resource "azurerm_public_ip" "hrwsrv01-ip" {
    name                         = "hrwsrv01ip"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "hrwsrv01ip-nsg" {
    name                = "hrwsrv01ip-nsg"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg.name
    
    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "hrwsrv01-nic" {
    name                          = "hrwsrv01-nic"
    location                      = "eastus"
    resource_group_name           = azurerm_resource_group.rg.name
    enable_accelerated_networking = true

    ip_configuration {
        name                          = "ipconfig1"
        subnet_id                     = azurerm_subnet.Subnet10.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.hrwsrv01-ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "hrwsrv01nsgassoc" {
  network_interface_id      = azurerm_network_interface.hrwsrv01-nic.id
  network_security_group_id = azurerm_network_security_group.hrwsrv01ip-nsg.id
}

resource "azurerm_managed_disk" "hrwsrv01_DataDisk_0" {
  name                 = "hrwsrv01_DataDisk_0"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"

  create_option        = "Empty"
  disk_size_gb         = "127"
}

resource "azurerm_virtual_machine_data_disk_attachment" "hrwsrv01datadiskattachment" {
  managed_disk_id    = azurerm_managed_disk.hrwsrv01_DataDisk_0.id
  virtual_machine_id = azurerm_windows_virtual_machine.hrwsrv01.id
  lun                =  0
  caching            = "ReadWrite"
}

resource "azurerm_windows_virtual_machine" "hrwsrv01" {
  name                = "hrwsrv01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS2_v2"
  admin_username      = "admin-local"
  admin_password      = "ReplaceMePassword01!"
  network_interface_ids = [
    azurerm_network_interface.hrwsrv01-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }
}

