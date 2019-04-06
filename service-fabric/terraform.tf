terraform {
  backend "azurerm" {
    storage_account_name  = "terraformstatest123"
    container_name        = "terraform-state-storage-container213123"
    key = "service-fabric-state"
    access_key                   = "Cn79/XfEb3sp7dy4FCXhjOM5msLafiTIKOrQ8fpMt4TsrBsQOr0w2qMB9XmkfQLTtvpYk/k/LV10mQ/BrJ7uzA=="
  }
}

provider "azurerm" {
  version = "v1.24"
}


