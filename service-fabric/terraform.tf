terraform {
  backend "azurerm" {
    storage_account_name  = "terraformstatest123"
    container_name        = "terraform-state-storage-container213123"
    key = "service-fabric-state"
    access_key                   = "Cn79/XfEb3sp7dy4FCXhjOM5msLafiTIKOrQ8fpMt4TsrBsQOr0w2qMB9XmkfQLTtvpYk/k/LV10mQ/BrJ7uzA=="
  }
}
variable "client_secret" {}
variable "tenant_id" {
  default = "986cdd8d-afd0-476b-9659-8e9387599abb"
}

provider "azurerm" {
  version = "v1.24"
  subscription_id = "e3441300-3ad3-4eca-8288-1f71a5778436"
  client_id       = "http://Terraform"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}
provider "azuread" {
  subscription_id = "e3441300-3ad3-4eca-8288-1f71a5778436"
  client_id       = "http://Terraform"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}


resource "azurerm_resource_group" "ServiceFabricTest" {
  location = "WestEurope"
  name = "ServiceFabricTest"
}

data "azuread_service_principal" "TerraformServicePrincipal"{
  display_name = "Terraform"
}

resource "azurerm_key_vault" "KeyVault" {
  location = "${azurerm_resource_group.ServiceFabricTest.location}"
  name = "KeyVault123123213"
  resource_group_name = "${azurerm_resource_group.ServiceFabricTest.name}"
  "sku" {
    name = "standard"
  }
  tenant_id = "${var.tenant_id}"

   access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${data.azuread_service_principal.TerraformServicePrincipal.id}"

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
resource "azurerm_key_vault_certificate" "SFCertificate" {
  name     = "imported-sf-cert"
  vault_uri = "${azurerm_key_vault.KeyVault.vault_uri}"

  certificate {
    contents = "${base64encode(file("certificate.pfx"))}"
    password = "abcd"
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 4096
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
