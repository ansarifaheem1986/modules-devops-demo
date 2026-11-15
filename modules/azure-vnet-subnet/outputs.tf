output "id" {
  description = "Resolved subnet resource ID."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].id : azurerm_subnet.managed[0].id
}

output "name" {
  description = "Resolved subnet name, carrying the creation dependency to consumers."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].name : azurerm_subnet.managed[0].name
}

output "address_prefixes" {
  description = "Address prefixes assigned to the resolved subnet."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].address_prefixes : azurerm_subnet.managed[0].address_prefixes
}
