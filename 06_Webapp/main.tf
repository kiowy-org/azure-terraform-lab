resource "random_pet" "name" {
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.name.id
  location = "France Central"
}

#TODO Use modules
module "vpc" {
  source = "./modules/vpc"
}

#TODO Récupérer Ubuntu 20.04 LTS
resource "azurerm_linux_virtual_machine_scale_set" "main_vm" {
  name                = "base_vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard_DS1_v2"
  instances           = 1
  admin_username      = "adminuser"
  admin_password      = "IsItWorking?"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id
    }
  }
}
