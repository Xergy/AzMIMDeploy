resource "azurerm_automation_account" "autoaccount" {
  name                = "hrwautoaccount"
  location            = "eastus"
  resource_group_name = "hrwrg"
  sku_name = "Basic"
}
