resource "azurerm_resource_group" "RG1" {
name = "RG1"
location = "Central India"

}

resorce "azurerm_resource_group" "RG2" {

    name = "RG2"
    location = "Central India"
    provider = azurerm.provider2-centralindia
}