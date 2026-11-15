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

module "subnet" {
  source = "../../../../modules/azure-vnet-subnet"
  count  = var.subnet_settings == null ? 0 : 1

  name                 = var.subnet_settings.name
  resource_group_name  = module.resource_groups[var.pep_defaults.resource_groups.default].name
  virtual_network_name = var.subnet_settings.virtual_network_name
  virtual_network_creation = {
    location      = module.resource_groups[var.pep_defaults.resource_groups.default].location
    address_space = var.subnet_settings.virtual_network_address_space
    tags          = var.pep_defaults.tags
  }
  creation = {
    address_prefixes = var.subnet_settings.address_prefixes
  }
}
