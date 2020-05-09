resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "hrwloganalytics"
  location            = "eastus"
  resource_group_name = "hrwrg"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_linked_service" "loganalyticslink" {
  resource_group_name = "hrwrg"
  workspace_name      = azurerm_log_analytics_workspace.loganalytics.name
  resource_id         = azurerm_automation_account.autoaccount.id
}