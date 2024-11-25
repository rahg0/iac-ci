variable "name" {
  description = "Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unqiue. If the vault is in a recoverable state then the vault will need to be purged before reusing the name."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
  type        = string
}
variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}
variable "enabled_for_deployment" {
  description = " Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. "
  type        = bool
  default     = false
}
variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}
variable "enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}
variable "enable_rbac_authorization" {
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  type        = bool
  default     = false
}
variable "purge_protection_enabled" {
  description = "Purge Protection enabled for this Key Vault"
  type        = bool
  default     = true
}
#variable "accessPolicies" {}
variable "tenant_id" {
  description = "tenant Id for Subscrption"
  type        = string
}
variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "standard"
}
variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 days."
  type        = number
  default     = 7
}
variable "network_acls_bypass" {
  description = "Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
  type        = string
  default     = "AzureServices"
}
variable "network_acls_default_action" {
  description = " Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type        = string
  default     = "Allow"
}
variable "network_acls_ip_rules" {
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
  type        = list(string)
  default     = []
}
variable "network_acls_subnet_ids" {
  description = " One or more Subnet IDs which should be able to access this Key Vault."
  type        = list(string)
  default     = []
}
#variable "contacts" {
#  description = "Contact Block"
#  type = list(object({
#    email = string,
#    name  = optional(string),
#    phone = optional(string)
#  }))
#  default = []
#}
variable "access_policies" {
  description = "Map of access policies for an object_id (user, service principal, security group) to backend."
  type = list(object({
    object_id               = string,
    certificate_permissions = list(string),
    key_permissions         = list(string),
    secret_permissions      = list(string),
    storage_permissions     = list(string),
  }))
  default = []
}
variable "default_tags" {
  type        = map(string)
  description = "Default tags for all resources"
}
variable "wk_data_classification" {
  description = "data classification tag value"
  type        = string
  default     = "confidential"
}
variable "subnet_id" {
  description = "subnet id to link to private endpoint"
  type        = string
  default     = null
}
variable "subresource_names" {
  description = "A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Changing this forces a new resource to be created."
  type        = set(string)
  default     = ["vault"]
}
variable "private_endpoint" {
  description = "Create private endpoint for kvt"
  type        = bool
  default     = false
}

variable "eventhub_name" {
  description = "Only need when using eventhub for sending logs.Specifies the name of the Event Hub where Diagnostics Data should be sent needs.If this isn't specified then the default Event Hub will be used. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
variable "logs_destinations_ids" {
  description = "List of destination resources IDs for logs diagnostic destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set."
  type        = list(string)
  default     = null
}
variable "log_categories" {
  type        = list(string)
  default     = null
  description = "List of log categories."
}

variable "metric_categories" {
  type        = list(string)
  default     = null
  description = "List of metric categories."
}
variable "retention_days" {
  type        = number
  default     = null
  description = "The number of days to keep diagnostic logs."
}
variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "When set to 'Dedicated' logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. Azure Data Factory is the only compatible resource so far."
}
variable "enable_logs" {
  type        = bool
  description = "enabe logs for diagnostic settings"
  default     = false
}
variable "enable_metrics" {
  type        = bool
  description = "enabe logs for diagnostic settings"
  default     = false
}
