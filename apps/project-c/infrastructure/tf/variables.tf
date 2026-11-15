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