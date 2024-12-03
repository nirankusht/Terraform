

resource "azurerm_resource_group" "RG01" {
  name     = "dev-terra"
  location = local.resource_location
}

resource "azurerm_virtual_network" "example" {
  name                = "terravnet"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.RG01.name
  address_space       = ["10.0.0.0/16"]
}
#   subnet {
#     name             = local.subnet_name[0]
#     address_prefixes = [local.subnet_prefix[0]]
#   }

#   subnet {
#     name             = local.subnet_name[1]
#     address_prefixes = [local.subnet_prefix[1]]
#   }

resource "azurerm_subnet" "websubnet01" {
  name                 = local.subnet_name[0]
  resource_group_name  = azurerm_resource_group.RG01.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [local.subnet_prefix[0]]

}

resource "azurerm_network_interface" "webnic01" {
  name                = "web-nic"
  location            = local.resource_location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webpip01.id
  }
}

resource "azurerm_public_ip" "webpip01" {
  name                = "web-pip"
  resource_group_name = local.rg_name
  location            = local.resource_location
  allocation_method   = "Static"
}


resource "azurerm_subnet" "appsubnet02" {
  name                 = local.subnet_name[1]
  resource_group_name  = azurerm_resource_group.RG01.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [local.subnet_prefix[1]]

}

output "websubnet01_id" {
value=azurerm_subnet.websubnet01.id

}
