terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.50"
    }
    time = {
      source = "hashicorp/time"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "azurerm" {
  features {}
}