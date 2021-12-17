resource "random_pet" "name" {
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.name.id
  location = "France Central"
}

module "vnet" {
  source = "./modules/vnet"

  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

module "mysql" {
  source = "./modules/mysql"

  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

module "autoscaler" {
  source = "./modules/autoscaler"

  rg_name    = azurerm_resource_group.main.name
  location   = azurerm_resource_group.main.location
  machine_id = #??
}

module "lb" {
  source = "./modules/lb"

  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

resource "azurerm_linux_virtual_machine_scale_set" "main_vm" {
  name                            = "scs"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  sku                             = "Standard_DS1_v2"
  instances                       = 1
  

  # Ubuntu 16.04...

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      # Compléter avec le subnet et le lb...
    }
  }
}
