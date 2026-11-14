data "azurerm_resource_group" "existing" {
  count = var.creation == null ? 1 : 0
  name  = var.name
}

resource "azurerm_resource_group" "managed" {
  count    = var.creation == null ? 0 : 1
  name     = var.name
  location = var.creation == null ? null : var.creation.location
  tags     = var.creation == null ? {} : var.creation.tags

  lifecycle {
    prevent_destroy = true
  }
}
