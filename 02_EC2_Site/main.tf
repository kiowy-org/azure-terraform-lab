resource "azurerm_resource_group" "apache_server" {
  name     = "kiowy-tp2-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "apache_server_sa" {
  name                      = "tp2_sa"
  resource_group_name       = azurerm_resource_group.apache_server.name
  location                  = azurerm_resource_group.apache_server.location
  account_tier              = "Standard"
  account_replication_type  = "DRS"
}

resource "azurerm_virtual_network" "apache_server_vnet" {
  name                = "kiowy-tp2-network"
  resource_group_name = azurerm_resource_group.apache_server.name
  location            = azurerm_resource_group.apache_server.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "tp2_subnet"
  resource_group_name  = azurerm_resource_group.apache_server.name
  virtual_network_name = azurerm_virtual_network.apache_server_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "apache_server_pip" {
  name                  = "tp2_public_ip"
  resource_group_name   = azurerm_resource_group.apache_server.name
  location              = azurerm_resource_group.apache_server.location
  allocation_method     = "Dynamic"
  domain_name_label     = "azure-tf-lab.kiowy.net"
}


resource "azurerm_security_group" "apache_server_sg" {
  name                          = "tp2-sg"
  resource_group_name           = azurerm_resource_group.apache_server.name
  location                      = azurerm_resource_group.apache_server.location

  security_rule {
    name                        = "HTTP"
    prority                     = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
      name                        = "SSH"
      prority                     = 101
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "22"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
  }
}

resource "azurerm_network_interface" "apache_server_nic" {
  name                = "tp2_nic"
  resource_group_name = azurerm_resource_group.apache_server.name
  location            = azurerm_resource_group.apache_server.location

  ip_configuration {
    name                          = "tp2_ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.apache_server_pip.id
  }
}

resource "azurerm_virtual_machine" "apache_server_vm" {
  name                  = "tp2-vm"
  location              = azurerm_resource_group.apache_server.location
  resource_group_name   = azurerm_resource_group.apache_server.name
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = ["${azurerm_network_interface.apache_server_nic.id}"]
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "tp2_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "tf_tp2"
    admin_username = "tp2admin"
    admin_password = "IsItWorking?"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
    Name = "Ben"
  }
}

provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y apache2",
    "sudo systemctl start apache2",
    "sudo systemctl enable apache2"
    "sudo echo "<h1>Hello Terraform</h1>" > /var/www/html/index.html",
  ]

  connection {
    protocol    = "ssh"
    host        = azurerm_public_ip.apache_server_pip.fqdn
    user        = "tp2admin"
    private_key = "IsItWorking?"
  }
}