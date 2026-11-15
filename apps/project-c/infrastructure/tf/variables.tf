variable "pep_defaults" {
  description = "EDAP defaults generated from this app's confirmed environment configuration."
  type = object({
    app_prefix      = string
    project_code    = string
    environment     = string
    subscription_id = string
    resource_groups = map(string)
    tags            = map(string)
  })
  validation {
    condition     = contains(["dev", "stage", "prod"], var.pep_defaults.environment)
    error_message = "project-c supports only dev, stage and prod."
  }
  validation {
    condition     = can(regex("^IACC-ProjectC-${var.pep_defaults.environment}-rg-[0-9]{2}$", var.pep_defaults.resource_groups.default))
    error_message = "The default resource group must follow IACC-ProjectC-<env>-rg-NN."
  }
}

variable "resource_group_settings" {
  description = "Explicit management settings keyed by resource group name."
  type = map(object({
    create   = bool
    location = string
    tags     = map(string)
  }))
  default = {}
}

variable "subnet_settings" {
  description = "Optional virtual network and subnet to create in the selected environment's default resource group."
  type = object({
    name                          = string
    virtual_network_name          = string
    virtual_network_address_space = list(string)
    address_prefixes              = list(string)
  })
  default = null

  validation {
    condition = var.subnet_settings == null ? true : (
      length(trimspace(var.subnet_settings.name)) > 0 &&
      length(trimspace(var.subnet_settings.virtual_network_name)) > 0 &&
      length(var.subnet_settings.virtual_network_address_space) > 0 &&
      alltrue([for prefix in var.subnet_settings.virtual_network_address_space : length(trimspace(prefix)) > 0]) &&
      length(var.subnet_settings.address_prefixes) > 0 &&
      alltrue([for prefix in var.subnet_settings.address_prefixes : length(trimspace(prefix)) > 0])
    )
    error_message = "Creating a virtual network and subnet requires their names and at least one non-empty address prefix for each."
  }
}