# VPC
resource "azurerm_virtual_network" "vpc" {
  name                = "virtualNetwork"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "internal" {
    name                 = "internal"
    resource_group_name  = var.rg_name
    virtual_network_name = azurerm_virtual_network.vpc.name
    address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "pip" {
  name                    = "pip"
  location                = var.location
  resource_group_name     = var.rg_name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
