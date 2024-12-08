resource "azurerm_network_interface" "main" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.interface_tags

  ip_configuration {
    name                          = "${var.name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group
  tags                  = var.tags
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_D2_v3"
  admin_username        = "azureuser"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.name}-osdisk1"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/sharaf-dg.pub")
  }
}
