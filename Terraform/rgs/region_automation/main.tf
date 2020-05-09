resource "azurerm_resource_group" "cu-env-ra-auto-rg" {
    name = "${var.prefix}-${var.env.name}-${var.ra.location_shortname}-auto-rg"           
    location = var.ra.location
}

