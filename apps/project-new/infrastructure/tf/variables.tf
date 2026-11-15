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
    condition     = contains(["dev", "qa", "stage", "prod"], var.pep_defaults.environment)
    error_message = "project-new supports only dev, qa, stage and prod."
  }
  validation {
    condition     = can(regex("^IACC-Devops-${var.pep_defaults.environment}(-new)?-rg-[0-9]{2}$", var.pep_defaults.resource_groups.default))
    error_message = "The default resource group must follow IACC-Devops-<env>(-new)-rg-NN."
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