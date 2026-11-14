output "id" {
  description = "Resource group ID."
  value       = var.creation == null ? data.azurerm_resource_group.existing[0].id : azurerm_resource_group.managed[0].id
}

output "name" {
  description = "Resolved name, carrying the creation dependency to consumers."
  value       = var.creation == null ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.managed[0].name
}

output "location" {
  description = "Actual group location."
  value       = var.creation == null ? data.azurerm_resource_group.existing[0].location : azurerm_resource_group.managed[0].location
}