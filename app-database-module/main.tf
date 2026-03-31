# Password generated and stored — never in plaintext in code
resource "random_password" "admin" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                = "${var.app_name}-${var.environment}-db"
  resource_group_name = var.resource_group_name
  location            = var.location

  version                       = var.postgresql_version
  administrator_login           = "app_admin"
  administrator_password        = random_password.admin.result
  sku_name                      = var.sku_name
  storage_mb                    = var.storage_mb

  # Fully private — no public endpoint
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id

  # Security defaults scaled by environment
  backup_retention_days         = var.environment == "prod" ? 30 : 7
  geo_redundant_backup_enabled  = var.environment == "prod" ? true : false

  high_availability {
    mode = var.environment == "prod" ? "ZoneRedundant" : "Disabled"
  }

  tags = {
    app_name    = var.app_name
    environment = var.environment
    managed_by  = "pulumi"
  }
}

resource "azurerm_postgresql_flexible_server_database" "app_db" {
  name      = replace(var.app_name, "-", "_")
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "utf8"
}