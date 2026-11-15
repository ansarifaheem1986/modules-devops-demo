output "resource_group_name" {
  description = "App-owned resource group."
  value       = local.pep_defaults.resource_groups.default
}

output "resource_group_id" {
  description = "App-owned resource group ID."
  value       = module.resource_groups[var.pep_defaults.resource_groups.default].id
}

output "resource_group_location" {
  description = "App-owned resource group region."
  value       = module.resource_groups[var.pep_defaults.resource_groups.default].location
}

output "subnet_id" {
  description = "Created subnet ID, or null when no subnet is configured."
  value       = try(module.subnet[0].id, null)
}

output "subnet_name" {
  description = "Created subnet name, or null when no subnet is configured."
  value       = try(module.subnet[0].name, null)
}

output "subnet_resource_group_name" {
  description = "Resource group containing the subnet, or null when no subnet is configured."
  value       = try(module.subnet[0].resource_group_name, null)
}

output "subnet_address_prefixes" {
  description = "Created subnet address prefixes, or null when no subnet is configured."
  value       = try(module.subnet[0].address_prefixes, null)
}