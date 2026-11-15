terraform {
  required_version = ">= 1.13.5, < 2.0.0"

  backend "azurerm" {
    resource_group_name  = "devops-iacc-dev-rg-01"
    storage_account_name = "tfstatefilesdev"
    container_name       = "module-stage-apps"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.13.0"
    }
  }
}


provider "azurerm" {
  features {}

  subscription_id                 = var.pep_defaults.subscription_id
  resource_provider_registrations = "none"
}