resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "origin" {
  name                     = "storageorigin${random_integer.rand.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "dest" {
  name                     = "storagedest${random_integer.rand.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "origin" {
  name                  = "origin"
  storage_account_name  = azurerm_storage_account.origin.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "dest" {
  name                  = "dest"
  storage_account_name  = azurerm_storage_account.dest.name
  container_access_type = "private"
}

resource "azurerm_service_plan" "plan" {
  name                = "function-copy-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = "func-copy-${random_integer.rand.result}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.origin.name
  storage_account_access_key = azurerm_storage_account.origin.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    AzureWebJobsStorage      = azurerm_storage_account.origin.primary_connection_string
    ORIGIN_CONTAINER         = azurerm_storage_container.origin.name
    DESTINATION_CONTAINER    = azurerm_storage_container.dest.name
    DESTINATION_CONNECTION   = azurerm_storage_account.dest.primary_connection_string
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
}
