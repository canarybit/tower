terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.50"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
    time = {
      source = "hashicorp/time"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}
