variable "azure_resource_group_name" {
    type = string
    description = "Azure resource group name" 
}

variable "key_vault_name"{
    type = string
    description = "Azure key vault name"
}

variable "azure_tenant_id" {
    type = string
    description = "azure tenant id"
}

variable "network_acl_action" {
    type = string
}
variable "network_acl_bypass" {
    type = string
}

variable "service_principals" {
    type = list
}
