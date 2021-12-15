resource "random_pet" "name" {
}

resource "azurerm_resource_group" "main" {
  name     = random_pet.name.id
  location = "France Central"
}