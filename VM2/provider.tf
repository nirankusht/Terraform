terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.11.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "840da5ef-b287-48af-b585-c4d68fcc2c39"
  features {}
}