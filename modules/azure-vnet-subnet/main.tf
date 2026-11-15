data "azurerm_subnet" "existing" {
  count                = var.creation == null ? 1 : 0
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

resource "azurerm_subnet" "managed" {
  count                = var.creation == null ? 0 : 1
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.creation == null ? [] : var.creation.address_prefixes

  lifecycle {
    prevent_destroy = true
  }
}
