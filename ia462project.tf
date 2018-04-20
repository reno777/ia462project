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
  name          = "Rivendell-Datacenter"
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
  name = "ia462project"
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

data "vsphere_virtual_machine" "template2" {
  name          = "gitTemplate"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template3" {
  name          = "splunkTemplate"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template4" {
  name          = "webTemplate"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template5" {
  name          = "dcTemplate"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template6" {
  name          = "win71Template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template7" {
  name          = "win72Template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "ubuntu" {
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
    label = "ubuntu.vmdk"
    size  = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
}

resource "vsphere_virtual_machine" "pfsense" {
  name             = "pfsense"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template1.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template1.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template1.network_interface_types[0]}"
  }

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template1.network_interface_types[0]}"
  }

 disk {
    label = "pfsense.vmdk"
    size  = "${data.vsphere_virtual_machine.template1.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template1.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template1.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template1.id}"
  }
}

resource "vsphere_virtual_machine" "git" {
  name             = "git"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template2.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template2.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template2.network_interface_types[0]}"
  }

  disk {
    label = "git.vmdk"
    size  = "${data.vsphere_virtual_machine.template2.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template2.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template2.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template2.id}"
  }
}

resource "vsphere_virtual_machine" "splunk" {
  name             = "splunk"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template3.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template3.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template3.network_interface_types[0]}"
  }

  disk {
    label = "splunk.vmdk"
    size  = "${data.vsphere_virtual_machine.template3.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template3.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template3.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template3.id}"
  }
}

resource "vsphere_virtual_machine" "web" {
  name             = "web"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template4.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template4.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template4.network_interface_types[0]}"
  }

  disk {
    label = "web.vmdk"
    size  = "${data.vsphere_virtual_machine.template4.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template4.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template4.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template4.id}"
  }
}

resource "vsphere_virtual_machine" "dc" {
  name             = "dc"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template5.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template5.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template5.network_interface_types[0]}"
  }

  disk {
    label = "dc.vmdk"
    size  = "${data.vsphere_virtual_machine.template5.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template5.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template5.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template5.id}"
  }
}

resource "vsphere_virtual_machine" "win71" {
  name             = "win71"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template6.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template6.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template6.network_interface_types[0]}"
  }

  disk {
    label = "win71.vmdk"
    size  = "${data.vsphere_virtual_machine.template6.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template6.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template6.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template6.id}"
  }
}

resource "vsphere_virtual_machine" "win72" {
  name             = "win72"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template7.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template7.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template7.network_interface_types[0]}"
  }

  disk {
    label = "win72.vmdk"
    size  = "${data.vsphere_virtual_machine.template7.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template7.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template7.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template7.id}"
  }
}
