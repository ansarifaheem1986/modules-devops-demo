output "id" {
  description = "Resolved subnet resource ID."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].id : azurerm_subnet.managed[0].id
}

output "name" {
  description = "Resolved subnet name, carrying the creation dependency to consumers."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].name : azurerm_subnet.managed[0].name
}

output "resource_group_name" {
  description = "Resource group containing the resolved subnet."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].resource_group_name : azurerm_subnet.managed[0].resource_group_name
}

output "address_prefixes" {
  description = "Address prefixes assigned to the resolved subnet."
  value       = var.creation == null ? data.azurerm_subnet.existing[0].address_prefixes : azurerm_subnet.managed[0].address_prefixes
}

output "virtual_network_id" {
  description = "ID of the existing or managed parent virtual network."
  value       = var.virtual_network_creation == null ? data.azurerm_virtual_network.parent[0].id : azurerm_virtual_network.managed[0].id
}

output "virtual_network_name" {
  description = "Name of the existing or managed parent virtual network."
  value       = var.virtual_network_name
}

output "virtual_network_address_space" {
  description = "Address spaces configured on the existing or managed parent virtual network."
  value       = var.virtual_network_creation == null ? data.azurerm_virtual_network.parent[0].address_space : azurerm_virtual_network.managed[0].address_space
}
