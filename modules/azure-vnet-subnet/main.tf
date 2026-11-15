data "azurerm_virtual_network" "parent" {
  count               = var.virtual_network_creation == null ? 1 : 0
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "managed" {
  count               = var.virtual_network_creation == null ? 0 : 1
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.virtual_network_creation.location
  address_space       = var.virtual_network_creation.address_space
  tags                = var.virtual_network_creation.tags
}

data "azurerm_subnet" "existing" {
  count                = var.creation == null ? 1 : 0
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_creation == null ? data.azurerm_virtual_network.parent[0].name : azurerm_virtual_network.managed[0].name
}

resource "azurerm_subnet" "managed" {
  count                = var.creation == null ? 0 : 1
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_creation == null ? data.azurerm_virtual_network.parent[0].name : azurerm_virtual_network.managed[0].name
  address_prefixes     = var.creation == null ? [] : var.creation.address_prefixes

  lifecycle {
    prevent_destroy = true
  }
}
