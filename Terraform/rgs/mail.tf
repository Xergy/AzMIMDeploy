provider "azurerm" {
    features {}
  }

module "region_automation" {
  source = "./region_automation"
  prefix = var.prefix
  ra = var.ra
  env = var.env
}