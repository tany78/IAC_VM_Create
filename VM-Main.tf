## Configure the vSphere Provider
provider "vsphere" {
    vsphere_server = var.vsphere_server
    user = var.vsphere_user
    password = var.vsphere_password
    allow_unverified_ssl = true
}

## Build VM
data "vsphere_datacenter" "dc" {
  name = "CaaS-Engg-Lab"
}

data "vsphere_datastore" "datastore" {
  name          = "CaaS-LAB-HX1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "IKS-RPool"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "mgmt_lan" {
  name          = "VM-DEF-100"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "IACTest2"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus   = 1
  memory     = 2048
  wait_for_guest_net_timeout = 0
  guest_id = "ubuntu64Guest"
  hardware_version = 13
  network_interface {
   network_id     = data.vsphere_network.mgmt_lan.id
   adapter_type   = "vmxnet3"
  }
  disk {
    label = "disk0"
    size  = 20
  }
}
