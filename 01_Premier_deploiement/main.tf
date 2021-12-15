terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.89.0"
    }
  }
}

provider "azurerm" {
  features {}
  # N'oubliez pas vos identifiants !
}

resource "random_pet" "name" {
}

resource "azurerm_resource_group" "example" {
  name     = "${random_pet.name.id}-exo1"
  location = "France Central"
}

resource "azurerm_storage_account" "example" {
  name                     = "${replace(random_pet.name.id, "-", "")}kiowy"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    owner = random_pet.name.id
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}