# Random ID for the Storage
resource "random_id" "storage_account" {
  prefix      = "storage"
  byte_length = "2"
}

# Create the storage account
resource "azurerm_storage_account" "storage" {
  name                     = lower(random_id.storage_account.hex)
  resource_group_name      = azurerm_resource_group.azmain.name
  location                 = azurerm_resource_group.azmain.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create the storage account container
resource "azurerm_storage_container" "container" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
