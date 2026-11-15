variable "name" {
  description = "Exact name of the existing or explicitly app-owned subnet."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "A subnet name is required."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group that contains the subnet."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "A resource group name is required."
  }
}

variable "virtual_network_name" {
  description = "Name of the existing or explicitly managed virtual network that contains the subnet."
  type        = string

  validation {
    condition     = length(trimspace(var.virtual_network_name)) > 0
    error_message = "A virtual network name is required."
  }
}

variable "virtual_network_creation" {
  description = "Null looks up an existing virtual network. Set this object to create and manage the virtual network."
  type = object({
    location      = string
    address_space = list(string)
    tags          = map(string)
  })
  default = null

  validation {
    condition = var.virtual_network_creation == null ? true : (
      length(trimspace(var.virtual_network_creation.location)) > 0 &&
      length(var.virtual_network_creation.address_space) > 0 &&
      alltrue([for prefix in var.virtual_network_creation.address_space : length(trimspace(prefix)) > 0])
    )
    error_message = "Creating a virtual network requires a location and at least one non-empty address space prefix."
  }
}

variable "creation" {
  description = "Null keeps the subnet lookup-only. Set explicit address prefixes to create a subnet owned by this Terraform state."
  type = object({
    address_prefixes = list(string)
  })
  default = null

  validation {
    condition = var.creation == null ? true : (
      length(var.creation.address_prefixes) > 0 &&
      alltrue([for prefix in var.creation.address_prefixes : length(trimspace(prefix)) > 0])
    )
    error_message = "Creating a subnet requires at least one non-empty address prefix."
  }
}
