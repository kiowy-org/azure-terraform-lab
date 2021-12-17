# VPC
resource "azurerm_virtual_network" "vpc" {
  name                = "virtualNetwork"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "internal"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.sg.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "pip" {
  name                    = "pip"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
