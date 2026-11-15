mock_provider "azurerm" {}

run "creates_project_c_default_resource_group" {
  command = plan

  variables {
    pep_defaults = {
      app_prefix      = "project-c"
      project_code    = "PROJECT-C"
      environment     = "dev"
      subscription_id = "00000000-0000-0000-0000-000000000000"
      resource_groups = {
        default = "IACC-ProjectC-dev-rg-01"
      }
      tags = {
        application = "project-c"
      }
    }

    resource_group_settings = {
      "IACC-ProjectC-dev-rg-01" = {
        create   = true
        location = "eastus"
        tags     = {}
      }
    }
  }

  assert {
    condition     = output.resource_group_name == "IACC-ProjectC-dev-rg-01"
    error_message = "project-c must target its configured default resource group."
  }

  assert {
    condition     = output.resource_group_location == "eastus"
    error_message = "project-c must use its configured resource group location."
  }
}
