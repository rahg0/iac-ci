#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "key_vault01" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled
  network_acls {
    bypass                     = var.network_acls_bypass
    default_action             = var.network_acls_default_action #"Allow"
    ip_rules                   = var.network_acls_ip_rules       # []
    virtual_network_subnet_ids = var.network_acls_subnet_ids     # []
  }
  tags = merge(var.default_tags, local.kvt_extra_tags)
  lifecycle {
    ignore_changes = [access_policy]
  }
  # This feature is currently an opt-in experiment, subject to change in future releases based on feedback
  # dynamic "contact" {
  #   for_each = var.contacts
  #   content {
  #     email = contact.value.email
  #     name  = lookup(contact.value, "name", null)
  #     phone = lookup(contact.value, "phone", contact.value)
  #   }
  # }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "main" {
  count        = length(var.access_policies)
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.access_policies[count.index].object_id

  secret_permissions      = var.access_policies[count.index].secret_permissions
  key_permissions         = var.access_policies[count.index].key_permissions
  certificate_permissions = var.access_policies[count.index].certificate_permissions
  storage_permissions     = var.access_policies[count.index].storage_permissions
}

resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.private_endpoint == true ? 1 : 0
  resource_group_name = var.resource_group_name
  name                = "${var.name}-pe"
  location            = var.location
  subnet_id           = var.subnet_id

  #  private_dns_zone_group {
  #    name                 = "${var.name}-group"
  #    private_dns_zone_ids = [var.private_dns_zone_ids]
  #  }

  private_service_connection {
    name                           = "${var.name}-pe-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = var.subresource_names
  }
  depends_on = [
    azurerm_key_vault_access_policy.main
  ]
  tags = merge(var.default_tags, local.pe_extra_tags)
}

output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "Resource Id for the Key Vault"
}

output "key_vault_name" {
  value       = azurerm_key_vault.key_vault.name
  description = "Name of the Key Vault"
}
module "diag" {
  count                          = var.enable_logs || var.enable_metrics == true ? 1 : 0
  source                         = "../DiagnosticSettings"
  name                           = "${var.name}-diag"
  resource_id                    = azurerm_key_vault.key_vault.id
  logs_destinations_ids          = var.logs_destinations_ids
  eventhub_name                  = var.eventhub_name
  log_categories                 = var.enable_logs == true ? var.log_categories : []
  metric_categories              = var.enable_metrics == true ? var.metric_categories : []
  retention_days                 = var.retention_days
  log_analytics_destination_type = var.log_analytics_destination_type
}
