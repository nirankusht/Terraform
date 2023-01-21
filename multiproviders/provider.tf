terraform{
required_version = ">=1.3.0"
required_providers {
  azurerm = {
    source = "hashicorp/azurerm"
      version = "3.39.1"
  }
}
}

provider "azurerm" {

features{

}

    # configuration options
}

#second provider
provider "azurerm" {

features{

virtual_machine {

delete_os_disk_on_deletion = false #this will not delete the disk when resource group deleted

}
}

alias = "provider2-centralindia"

}



