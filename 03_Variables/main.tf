resource "random_pet" "name" {
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.name.id
  location = "France Central"
}

resource "azurerm_virtual_network" "apache_server_vnet" {
  name                = "${random_pet.name.id}-kiowy-tp2-net"
  resource_group_name = azurerm_resource_group.apache_server.name
  location            = azurerm_resource_group.apache_server.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${random_pet.name.id}-tp2_subnet"
  resource_group_name  = azurerm_resource_group.apache_server.name
  virtual_network_name = azurerm_virtual_network.apache_server_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "apache_server_pip" {
  name                = "${random_pet.name.id}-tp2_public_ip"
  resource_group_name = azurerm_resource_group.apache_server.name
  location            = azurerm_resource_group.apache_server.location
  allocation_method   = "Static"
}


resource "azurerm_network_security_group" "apache_server_sg" {
  name                = "${random_pet.name.id}-tp2-sg"
  resource_group_name = azurerm_resource_group.apache_server.name
  location            = azurerm_resource_group.apache_server.location

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "apache_server_nic" {
  name                = "${random_pet.name.id}-tp2_nic"
  resource_group_name = azurerm_resource_group.apache_server.name
  location            = azurerm_resource_group.apache_server.location

  ip_configuration {
    name                          = "tp2_ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.apache_server_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "apache_server_vm" {
  name                = "${random_pet.name.id}-tp2-vm"
  location            = azurerm_resource_group.apache_server.location
  resource_group_name = azurerm_resource_group.apache_server.name
  size                = "Standard_DS1_v2"

  admin_username                  = "tp2admin"
  admin_password                  = "IsItWorking?"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.apache_server_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = base64encode(file("./apache_script.sh"))

}