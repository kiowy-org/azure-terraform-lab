resource "random_pet" "name" {
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.name.id
  location = "France Central"
}

#TODO Use modules
module "vpc" {
  source = "./modules/vpc"

  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

module "rds" {
  source = "./modules/rds"

  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

module "autoscaler" {
  source = "./modules/autoscaler"

  rg_name    = azurerm_resource_group.main.name
  location   = azurerm_resource_group.main.location
  machine_id = azurerm_linux_virtual_machine_scale_set.main_vm.id
}

module "lb" {
  source = "./modules/lb"

  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

#TODO Récupérer Ubuntu 20.04 LTS
resource "azurerm_linux_virtual_machine_scale_set" "main_vm" {
  name                            = "scs"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  sku                             = "Standard_DS1_v2"
  instances                       = 1
  admin_username                  = "adminuser"
  admin_password                  = "IsItWorking?"
  disable_password_authentication = false

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
      name                                   = "internal"
      primary                                = true
      subnet_id                              = module.vpc.internal_subnet_id
      load_balancer_backend_address_pool_ids = [module.lb.lb_pool_id]
    }
  }
}
