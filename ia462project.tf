##Group Project for IA 462
##By Seth and Pat

provider "vsphere" {
  user            = "terraform@vsphere.local"
  password        = "P@ssw0rd13"
  vsphere_server  = "192.168.1.75"

  #if you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc"{
  name = "Rivendell-Datacenter"
}

data "vsphere_datastore" "datastore"{
  name          = "host2-datastore"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_resource_pool" "pool" {
  name          = "testForProject"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network"{
  name = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network1"{
  name = "ia-DSwitch/ia462project"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntuTemplate"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template1" {
  name          = "pfsenseTemplate"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "ubuntu"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label = "disk0"
    size  = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
#
#    customize {
#      linux_options {
#        host_name = "terraform-test"
#        domain = drunkle.bgp
#      }
#
#      network_interface {
#        ipv4_address = "10.10.0.56"
#        ipv4_netmask = 24
#      }
#
#      ipv4_gateway = "10.10.0.1"
#    }
  }
}

resource "vsphere_virtual_machine" "vm1" {
  name             = "pfsense"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template1.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template1.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template1.network_interface_types[0]}"
  }

  disk {
    label = "disk0"
    size  = "${data.vsphere_virtual_machine.template1.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template1.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template1.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template1.id}"
#
#    customize {
#      linux_options {
#        host_name = "terraform-test"
#        domain = drunkle.bgp
#      }
#
#      network_interface {
#        ipv4_address = "10.10.0.56"
#        ipv4_netmask = 24
#      }
#
#      ipv4_gateway = "10.10.0.1"
#    }
  }
}
