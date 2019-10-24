//first I specify the Azure resource group that I will be using, every resource I will be creating next will be within this resource group
resource "azurerm_resource_group" "project1_rg" {
  location = var.location
  name     = "project1_rg"
}

//I create a VNet in which the VM will be located
resource "azurerm_virtual_network" "project1_rg_vn" {
  address_space       = ["10.0.0.0/20"]
  location            = var.location
  name                = "project1_rg"
  resource_group_name = azurerm_resource_group.project1_rg.name
}

//I specify a subnet within the created VNet above
resource "azurerm_subnet" "project1_rg_sub" {
  address_prefix       = "10.0.1.0/24"
  name                 = "project1_rg_sub"
  resource_group_name  = azurerm_resource_group.project1_rg.name
  virtual_network_name = azurerm_virtual_network.project1_rg_vn.name
}

//I create a public IP that I will use for the VM in order to access it from internet
resource "azurerm_public_ip" "project1_rg_pub" {
  location = var.location
  name = "project1_rg_pub"
  resource_group_name = azurerm_resource_group.project1_rg.name
  public_ip_address_allocation = "dynamic"
}

//I create a NIC that I put in my subnet and link the public IP to it and that I'll attach to the VM
resource "azurerm_network_interface" "project1_rg_nic" {
  location            = var.location
  name                = "project1_rg_nic"
  resource_group_name = azurerm_resource_group.project1_rg.name
  ip_configuration {
    name                          = "IPv4"
    private_ip_address_allocation = "dynamic"
    subnet_id = azurerm_subnet.project1_rg_sub.id
    public_ip_address_id = azurerm_public_ip.project1_rg_pub.id
  }
}

//I then create the VM with following:
resource "azurerm_virtual_machine" "project1_rg_vm" {
  location              = var.location
  name                  = "machine"
  network_interface_ids = [azurerm_network_interface.project1_rg_nic.id]
  resource_group_name   = azurerm_resource_group.project1_rg.name
  vm_size               = "Standard_B1ls"

  storage_os_disk {
    create_option = "FromImage"
    name          = "project1_rg_vm_disk"
  }

  storage_image_reference {
    publisher = "Debian"
    offer     = "Debian-10"
    sku       = "10"
    version   = "latest"
  }

  os_profile {
    admin_username = "admin"
    admin_password = "P@ssword_D3bian"
    computer_name = "debian"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}

//with the declaration below, I'm passing a startup shell script that will install nginx and point on the custom web page
//the script should be base64 encoded.
resource "azurerm_virtual_machine_extension" "project1_rg_vm_ext" {
  location = var.location
  name = "project1_rg_vm_disk_ext"
  publisher = "Microsoft.Azure.Extensions"
  resource_group_name = azurerm_resource_group.project1_rg.name
  type = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_name = azurerm_virtual_machine.project1_rg_vm.name
  settings = <<SETTINGS
    {
    "script" : "c3VkbyBhcHQtZ2V0IC15IGluc3RhbGwgbmdpbngKY2QgL2V0Yy9uZ2lueC9zaXRlcy1lbmFibGVkCnN1ZG8gc2VkIC1pICdzL2xpc3RlbiA4MCBkZWZhdWx0X3NlcnZlcjsvbGlzdGVuIDgwODAgZGVmYXVsdF9zZXJ2ZXI7L2cnIGRlZmF1bHQKY2QgL3Zhci93d3cvaHRtbApzdWRvIGNob3duIGJhZHIgLgpzdWRvIG12IGluZGV4Lm5naW54LWRlYmlhbi5odG1sIGluZGV4Lmh0bWwub2xkCnN1ZG8gZWNobyAiZnVjayBvZmYgZnJvbSBteSBzaXRlLiBCYWRyIG9uIEF6dXJlIiA+IGluZGV4Lmh0bWwKc3VkbyBzeXN0ZW1jdGwgcmVzdGFydCBuZ2lueAo="
   }
SETTINGS
}