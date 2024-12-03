
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.11.0"
    }
  }
}

provider "azurerm" {

    subscription_id = "840da5ef-b287-48af-b585-c4d68fcc2c39"
  features {}
}

variable "prefix" {
  default = "DEVENV001"
}

resource "azurerm_resource_group" "RGDEV" {
  name     = "${var.prefix}-resources"
  location = "Central India"
}

resource "azurerm_virtual_network" "VN001" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RGDEV.location
  resource_group_name = azurerm_resource_group.RGDEV.name
}

resource "azurerm_subnet" "internal" {
  name                 = "SUB1"
  resource_group_name  = azurerm_resource_group.RGDEV.name
  virtual_network_name = azurerm_virtual_network.VN001.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "NIC001" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.RGDEV.location
  resource_group_name = azurerm_resource_group.RGDEV.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "VM001" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.RGDEV.location
  resource_group_name   = azurerm_resource_group.RGDEV.name
  network_interface_ids = [azurerm_network_interface.NIC001.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "HOST098"
    admin_username = "ntyagi1"
    admin_password = "Batman!09876"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "dev"
  }
}