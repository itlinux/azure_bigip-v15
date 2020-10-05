# Random ID for the Storage
resource "random_id" "storage_account" {
  count       = var.specs[terraform.workspace]["instance_count"]
  prefix      = "storage"
  byte_length = "3"
}

# Create the storage account
resource "azurerm_storage_account" "storage" {
  count                    = var.specs[terraform.workspace]["instance_count"]
  name                     = lower(random_id.storage_account[count.index].hex)
  resource_group_name      = azurerm_resource_group.azmain.name
  location                 = azurerm_resource_group.azmain.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create the storage account container
resource "azurerm_storage_container" "container" {
  count                 = var.specs[terraform.workspace]["instance_count"]
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.storage[count.index].name
  container_access_type = "private"
}
