module "resource_groups" {
  source   = "../../../../modules/azure-resource-group"
  for_each = toset(values(var.pep_defaults.resource_groups))

  name = each.key
  creation = try(var.resource_group_settings[each.key].create, false) ? {
    location = var.resource_group_settings[each.key].location
    tags     = merge(var.pep_defaults.tags, var.resource_group_settings[each.key].tags)
  } : null
}

locals {
  pep_defaults = merge(var.pep_defaults, {
    resource_groups = {
      for alias, name in var.pep_defaults.resource_groups : alias => module.resource_groups[name].name
    }
  })
}
