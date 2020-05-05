# Create an Azure Key Vault

terraform{
    # This block is filled by terragrunt
    backend "azurerm" {}
}

#Configure the Azure Provider
provider "azurerm"{
    version = "2.0.0"
    features  {
        key_vault  {
            purge_soft_delete_on_destroy = true
        }
    }
}

data "azurerm_resource_group" "rsg"{
    name = var.azure_resource_group_name
}

resource "azurerm_key_vault" "kv"{
    name                            = var.key_vault_name
    location                        = data.azurerm_resource_group.rsg.location
    resource_group_name             = data.azurerm_resource_group.rsg.name
    enabled_for_disk_encryption     = false
    tenant_id                       = var.azure_tenant_id
    sku_name                        = "standard"

    network_acls {
    default_action = var.network_acl_action
    bypass         = var.network_acl_bypass
  }

  tags = {
      Application             = "Test"
      CostCentre              = "1234"
      Environment             = "Development"
      Support                 = "support@test.com"
      System                  = "Test System"
      Team                    = ""
  }
}

resource "azurerm_key_vault_access_policy" "sp_policy" {
  count         = length(var.service_principals)
  key_vault_id  = azurerm_key_vault.kv.id
  tenant_id = var.azure_tenant_id
  object_id = element(var.service_principals.*.object_id, count.index)
  key_permissions             = element(var.service_principals.*.key_permissions, count.index)
  certificate_permissions     = element(var.service_principals.*.certificate_permissions, count.index)
  secret_permissions          = element(var.service_principals.*.secret_permissions, count.index)
  depends_on = [
    azurerm_key_vault.kv
  ]

}