mock_provider "azurerm" {}

run "creates_explicitly_configured_subnet" {
  command = plan

  variables {
    name                 = "project-c-dev-subnet-01"
    resource_group_name  = "IACC-ProjectC-dev-rg-01"
    virtual_network_name = "IACC-ProjectC-dev-vnet-01"
    creation = {
      address_prefixes = ["10.20.1.0/24"]
    }
  }

  assert {
    condition     = output.name == "project-c-dev-subnet-01"
    error_message = "The module must expose the configured subnet name."
  }

  assert {
    condition     = tolist(output.address_prefixes) == tolist(["10.20.1.0/24"])
    error_message = "The module must expose the configured subnet address prefixes."
  }
}

run "rejects_creation_without_address_prefixes" {
  command = plan

  variables {
    name                 = "project-c-dev-subnet-invalid"
    resource_group_name  = "IACC-ProjectC-dev-rg-01"
    virtual_network_name = "IACC-ProjectC-dev-vnet-01"
    creation = {
      address_prefixes = []
    }
  }

  expect_failures = [var.creation]
}
