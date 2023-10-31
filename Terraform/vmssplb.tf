# a.	A single web page(HTML) hosted on an auto scaling group.(Default nodes =2). Web servers should  be in Compute Subnet. (Refer annex 1 - (1) for HTML file content.)
# b.	The web service should be behind an Load Balancer, place this load balancer in the DMZ subnet. Load balance with sticky IP algo.
# c.	A security group that allows only 1 local IP address to ssh into the vm instances.
#    Only IP : 172.33.128.50 is allowed to SSH to the VM Instances.

#Provider
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "myvmssrg3"
  location = "East Asia"
}

# Vitural network
resource "azurerm_virtual_network" "myvnet" {
  name                = "vmssvnet"
  address_space       = ["172.33.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

# Subnet Compute
resource "azurerm_subnet" "compute" {
  name                 = "compute"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["172.33.128.0/18"] # compute with a /18 prefix
  depends_on           = [azurerm_virtual_network.myvnet]
}

# Subnet DMZ
resource "azurerm_subnet" "dmz" {
  name                 = "dmz"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["172.33.0.0/18"] # dmz with a /18 prefix
  depends_on           = [azurerm_virtual_network.myvnet]
}

## NSG for VMSS
resource "azurerm_network_security_group" "myvmssnsg" {
  name                = "myvmssnsg"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

resource "azurerm_network_security_rule" "nsgInrule1" {
  name                        = "SSH-allow"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "172.33.128.50"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.myvmssnsg.name

}

resource "azurerm_network_security_rule" "nsgInrule2" {
  name                        = "LB-allow"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.myvmssnsg.name
}

resource "azurerm_network_security_rule" "nsgInrule3" {
  name                        = "DenyAll"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.myvmssnsg.name
}


#resource "azurerm_network_security_rule" "nsgoutrule1" {
 # name                        = "Outbound_access_to_internet"
 # priority                    = 200
 # direction                   = "Outbound"
 # access                      = "Allow"
 # protocol                    = "Tcp"
 # source_port_range           = "*"
 # destination_port_range      = "*"
 # source_address_prefix       = "*"
 # destination_address_prefix  = "Internet"
 # resource_group_name         = azurerm_resource_group.myrg.name
 # network_security_group_name = azurerm_network_security_group.myvmssnsg.name
#}


##Azure Load balancer

#Load balance public IP for VMs to have outbound internet connectivity
resource "azurerm_public_ip" "pub_ip" {
  name                = "lbpubip"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Load balancer config

resource "azurerm_lb" "vmss_lb" {
  name                = "vmsslb"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  frontend_ip_configuration {
    name      = "frontend-ip"
    #subnet_id = azurerm_subnet.dmz.id
    #private_ip_address_allocation = "Dynamic"
    #private_ip_address_version    = "IPv4"
    public_ip_address_id = azurerm_public_ip.pub_ip.id
  }

 # depends_on = [
 #   azurerm_subnet.dmz
 # ]
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "vmsspool" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "vmsspool"
  depends_on = [
    azurerm_lb.vmss_lb
  ]
}

#Health Probe
resource "azurerm_lb_probe" "Probe1" {
  #resource_group_name = azurerm_resource_group.myrg.name
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "Probe1"
  port            = 80
  protocol        = "Tcp"
  depends_on = [
    azurerm_lb.vmss_lb
  ]
}

#Load Balancing Rule
resource "azurerm_lb_rule" "Rule1" {
  #resource_group_name            = azurerm_resource_group.myrg.name
  loadbalancer_id                = azurerm_lb.vmss_lb.id
  name                           = "Rule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat = true
  frontend_ip_configuration_name = "frontend-ip"
  probe_id                       = azurerm_lb_probe.Probe1.id
  load_distribution              = "SourceIP"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vmsspool.id]
}

# This will block the inbound internet access
#resource "azurerm_subnet_network_security_group_association" "Compute_nsg" {
#  subnet_id                 = azurerm_subnet.compute.id
# network_security_group_id = azurerm_network_security_group.myvmssnsg.id
#}

resource "azurerm_lb_outbound_rule" "example" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.vmss_lb.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vmsspool.id
  frontend_ip_configuration {
    name = "frontend-ip"
  }
}
##VM Scale Set

resource "azurerm_linux_virtual_machine_scale_set" "myvmss" {
  name                            = "my-vmss"
  resource_group_name             = azurerm_resource_group.myrg.name
  location                        = azurerm_resource_group.myrg.location
  sku                             = "Standard_DS1_v2"
  instances                       = 2
  admin_username                  = "adminuser"
  admin_password                  = "!tempP@ss"
  disable_password_authentication = false
  upgrade_mode                    = "Automatic"
  network_interface {
    name                      = "nic"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.myvmssnsg.id

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.compute.id
      #public_ip_address          = azurerm_public_ip.pub_ip.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmsspool.id]
    }

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  connection {
    type     = "ssh"
    user     = "adminuser"
    password = "!tempP@ss"
    host     = azurerm_linux_virtual_machine_scale_set.myvmss.id

  }
}

## Online storage for script
resource "azurerm_storage_account" "scriptstore" {
  name                     = "scriptstore20231017123"
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = azurerm_resource_group.myrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "scriptfile" {
  name                  = "scriptfile"
  storage_account_name  = azurerm_storage_account.scriptstore.name
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.scriptstore
  ]
}

# Uploading script to blob
resource "azurerm_storage_blob" "script" {
  name                   = "script.sh"
  storage_account_name   = azurerm_storage_account.scriptstore.name
  storage_container_name = "scriptfile"
  type                   = "Block"
  source                 = "script.sh"
  depends_on             = [azurerm_storage_container.scriptfile]
}

## Custom script extenstion for the VMSS
resource "azurerm_virtual_machine_scale_set_extension" "scaleset_extension" {
  name                         = "scaleset-extension"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.myvmss.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.1"
  depends_on = [
    azurerm_storage_blob.script
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.scriptstore.name}.blob.core.windows.net/scriptfile/script.sh"],
          "commandToExecute": "/bin/bash script.sh"     
    }
SETTINGS
}
