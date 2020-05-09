resource "azurerm_storage_account" "storageaccount" {
  name                     = "hrwsa"
  resource_group_name      = "hrwrg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storageaccountcontainer" {
  name                  = "azinfo"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}