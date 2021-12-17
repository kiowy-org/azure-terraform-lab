# VPC
resource "azurerm_virtual_network" "vpc" {
  name                = "virtualNetwork"
  location            = var.location
  resource_group_name = var.rg_name
  # 10.0.0.0/16
}

resource "azurerm_subnet" "internal" {
    name                 = "internal"
    resource_group_name  = var.rg_name
    # 10.0.1.0/24
}


resource "azurerm_network_security_group" "apache_server_sg" {
  name                = "webapp-sg"
  resource_group_name = var.rg_name
  location            = var.location

  # Allow 80

  # Allow SSH
}