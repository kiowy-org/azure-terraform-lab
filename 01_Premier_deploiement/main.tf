terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_container" "example" {
  name                  = "test.tf.formation.kiowy.com"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "blob.zip"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  source                 = "some-local-blob.file.zip"
}

# La configuration de base de la formation AWS
resource "azurerm_resource_group" "monbucket" {
  bucket = "test.tf.formation.kiowy.com"
  acl    = "public-read"

  tags = {
    Name  = "Mon Bucket"
    Owner = "Benjamin"
  }
}