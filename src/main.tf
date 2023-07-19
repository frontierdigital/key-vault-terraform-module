resource "azurerm_key_vault" "main" {
  name                = "${var.zone}-${var.environment}-${lookup(local.short_locations, var.location)}-${local.identifier}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_rbac_authorization = true
  sku_name                  = var.sku_name
  tenant_id                 = var.tenant_id

  tags = merge(var.tags, local.tags)
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "log-analytics"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AuditEvent"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
