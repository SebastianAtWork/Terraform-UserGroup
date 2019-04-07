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
provider "azuread" {
  version = ""
}
data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "ServiceFabricTest" {
  location = "WestEurope"
  name = "ServiceFabricTest"
}

resource "azuread_application" "ServiceFabricTestApp" {
  name                       = "example"
  homepage                   = "https://homepage"
  identifier_uris            = ["http://uri"]
  reply_urls                 = ["http://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

data "azurerm_azuread_application" "ServiceFabricTestAppReference"{
  name = "${azuread_application.ServiceFabricTestApp.name}"
}
resource "azuread_service_principal" "TestAppServicePrincipal" {
  application_id = "${data.azurerm_azuread_application.ServiceFabricTestAppReference.application_id}"

  tags = ["example", "tags", "here"]
}

resource "azurerm_key_vault" "KeyVault" {
  location = "${azurerm_resource_group.ServiceFabricTest.location}"
  name = "KeyVault123123213"
  resource_group_name = "${azurerm_resource_group.ServiceFabricTest.name}"
  "sku" {
    name = "standard"
  }
  tenant_id = "${data.azurerm_client_config.current.tenant_id}"

   access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${azuread_service_principal.TestAppServicePrincipal.id}"

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }

  tags = {
    environment = "Test"
  }
}
