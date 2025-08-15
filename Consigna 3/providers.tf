terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.78.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "4dc63939-80f6-4f50-bd19-bc605cf2786d"
}