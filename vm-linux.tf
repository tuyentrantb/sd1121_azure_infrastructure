resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.resource_prefix}storageaccount"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = module.label.tags
}

resource "azurerm_linux_virtual_machine" "terraform_vm" {
  name                  = "${var.resource_prefix}-VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.resource_prefix}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

  tags = module.label.tags
}
