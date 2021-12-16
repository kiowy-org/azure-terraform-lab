# VPC
resource "azurerm_virtual_network" "" {
    # Public subnets
    subnet {

    }

    # Private subnets
    subnet {

    }
}


# Internet GW
resource "azurerm_virtual_network_gateway" "" {

}

# Elastic IP for NAT gw
resource "azurerm_public_ip" "" {
  
}

resource "azurerm_public_ip_prefix" ""{

}

# Nat gw
resource "azurerm_nat_gateway" "" {
  
}

# Private route tables
resource "azurerm_route_table" "" {
  
}

# Route associations private
resource "azurerm_subnet_route_table_association" "" {
  
}
