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