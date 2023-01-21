
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.40.0"
    }
  }
}

provider "azurerm" {
  
features{}

}


resource "azurerm_resource_group" "RG-1" {
  name     = "RG1"
  location = "Central India"
}

resource "azurerm_virtual_network" "VN-1" {
  name                = "VN1"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.RG-1
  ]

}

resource "azurerm_subnet" "SUB-1"{

  name                 = "SUB1"
  resource_group_name  = azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.RG-1.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.VN-1
  ]

}


resource "azurerm_network_interface" "appinterface" {
  name                = "app-interface"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.SUB-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.app_public_ip.id
  }

depends_on = [
  azurerm_public_ip.app_public_ip
]

}

resource "azurerm_public_ip" "app_public_ip" {
  name                = "pubip"
  resource_group_name = azurerm_resource_group.RG-1.name
  location            = azurerm_resource_group.RG-1.location
  allocation_method   = "Static"

depends_on = [
  azurerm_resource_group.RG-1
]
}







