variable "name" {
  description = "Exact name of the existing or explicitly app-owned resource group."
  type        = string
  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "A resource group name is required."
  }
}

variable "creation" {
  description = "Null keeps the group lookup-only. Set an explicit location and tags only for a group owned by this app state."
  type = object({
    location = string
    tags     = map(string)
  })
  default = null
  validation {
    condition = var.creation == null ? true : (
      var.creation.location == null ? false : length(trimspace(var.creation.location)) > 0
    )
    error_message = "Creating a resource group requires an explicit location."
  }
}