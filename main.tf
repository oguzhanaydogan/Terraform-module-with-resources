terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.37.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}
module "rg" {
    source = "./module/rg"
    rg_name = "friday"
    location = "eastus"
}
module "vnet" {
    source = "./module/vnet"
    vnet_name = "vnet-eastus"
    address_space = ["10.0.0.0/16"]
    location = module.rg.location
    rg_name = module.rg.name
}
module "subnet" {
    source = "./module/subnet"
    subnet_name = "integral"
    rg_name = module.rg.name
    vnet_name = module.vnet.name
    address_prefixes = ["10.0.0.0/26"]
}
module "vm" {
    source = "./module/vm"
    vm_name = "friday-${count.index}"
    location = module.rg.location
    rg_name = module.rg.name
    subnet_id = module.subnet.id
    count = 3
  
}
module "sa" {
    source = "./module/sa"
    sa_name = "oguzhanaydoganfriday"
    rg_name = module.rg.name
    location = module.rg.location
  
}