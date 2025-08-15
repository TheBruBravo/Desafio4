output "function_app_name" {
  value = azurerm_linux_function_app.func.name
}

output "origin_container_url" {
  value = azurerm_storage_account.origin.primary_blob_endpoint
}

