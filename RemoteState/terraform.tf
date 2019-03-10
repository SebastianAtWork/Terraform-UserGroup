
terraform {
  backend "azurerm" {
    storage_account_name  = "terraformstatest123"
    container_name        = "terraform-state-storage-container213123"
    key = "terraformstate-state"
    access_key                   = "Cn79/XfEb3sp7dy4FCXhjOM5msLafiTIKOrQ8fpMt4TsrBsQOr0w2qMB9XmkfQLTtvpYk/k/LV10mQ/BrJ7uzA=="
  }
}

provider "azurerm" {
  version = "v1.22.1"
}

resource "azurerm_resource_group" "TerraformState" {

  location = "westeurope"
  name = "TerraformState"
}

resource "azurerm_storage_account" "terraform_state_storage" {
name                     = "terraformstatest123"
  resource_group_name      = "${azurerm_resource_group.TerraformState.name}"
  location                 = "${azurerm_resource_group.TerraformState.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "terraform_state_storage_container" {
  name = "terraform-state-storage-container213123"
  resource_group_name = "${azurerm_resource_group.TerraformState.name}"
  storage_account_name = "${azurerm_storage_account.terraform_state_storage.name}"
}

