resource "azurerm_public_ip" "lb-pip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb-pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lbpool" {
 loadbalancer_id     = azurerm_lb.lb.id
 name                = "BackEndAddressPool"
}