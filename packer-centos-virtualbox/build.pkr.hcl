
# Packer Build File

build {
    sources = [
        "source.virtualbox-iso.packer-centos-virtualbox",
        "source.vsphere-iso.packer-centos-vsphere"
    ]

    # install ansible
    provisioner "shell" {
        script = "${path.root}/scripts/ansible.sh"
    }

    # provision
    provisioner "ansible-local" {
        playbook_file   = "${path.cwd}/../ansible/provision.yml"
        playbook_dir    = "${path.cwd}/../ansible"
        extra_arguments = [ "--extra-vars", "'{\"box_name\":\"${var.box_name}\", \"box_version\":\"${var.box_version}\"}'" ]
    }

    # remove ansible
    provisioner "shell" {
        script = "${path.root}/scripts/remove.sh"
    }

    # cleanup image
    provisioner "shell" {
        script = "${path.root}/scripts/template.sh"
    }

    post-processors {
        # create Vagrant box (Only for VirtualBox)
        post-processor "vagrant" {
            only   = ["source.virtualbox-iso.packer-centos-virtualbox"]
            output = "${path.cwd}/build/{{.Provider}}-${var.box_name}.box"
        }

        # upload to Vagrant cloud (Only for VirtualBox)
        post-processor "vagrant-cloud" {
            only    = ["source.virtualbox-iso.packer-centos-virtualbox"]
            box_tag = "jakemalley/${var.box_name}"
            version = "${var.box_version}"
        }
    }
}

## VirtualBox
source "virtualbox-iso" "packer-centos-virtualbox" {

    # VM
    vm_name       = "packer-${var.box_name}-${var.box_version}-x86_64"
    headless      = true
    disk_size     = 61440
    guest_os_type = "RedHat_64"
    vboxmanage    = [
        [ "modifyvm", "{{.Name}}", "--memory", "2048" ],
        [ "modifyvm", "{{.Name}}", "--cpus", "2" ]
    ]

    # Virtual Box
    guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
    virtualbox_version_file = ".vbox_version"

    # SSH
    ssh_username = "root"
    ssh_password = "redhat123"
    ssh_port     = 22
    ssh_timeout  = "1800s"

    shutdown_command = "/sbin/halt -h -p"

    # ISO
    iso_url      = var.boot_iso_url
    iso_checksum = var.boot_iso_checksum

    # Boot
    boot_wait    = "10s"
    boot_command = [
        "<tab>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "quiet text inst.repo=${var.installation_repo} inst.ks=cdrom:/dev/sr1:/ks.cfg<enter><wait>",
    ]

    # Kickstart
    cd_files = ["${path.root}/ks/ks.cfg"]
    cd_label = "cidata"
}

# VMware
source "vsphere-iso" "packer-centos-vsphere" {
    # vCenter Details
    vcenter_server      = "${var.vcenter_server}"
    username            = "${var.vcenter_username}"
    password            = "${var.vcenter_password}"
    insecure_connection = "${var.vcenter_insecure_connection}"
    cluster             = "${var.vcenter_cluster}"
    resource_pool       = "${var.vcenter_resource_pool}"
    datastore           = "${var.vcenter_datastore}"
    folder              = "${var.vcenter_folder}"

    # VM
    vm_name              = "packer-${var.box_name}-${var.box_version}-x86_64"
    guest_os_type        = "rhel7_64Guest"
    CPUs                 = 2
    CPU_hot_plug         = true
    RAM                  = 2048
    RAM_hot_plug         = true
    RAM_reserve_all      = false
    disk_controller_type = ["pvscsi"]
    storage {
        disk_size             = 61440
        disk_thin_provisioned = true
    }
    network_adapters {
        network      = "${var.vcenter_network}"
        network_card = "vmxnet3"
    }
    notes         = "Packer Template: ${var.box_name} v${var.box_version}"

    # SSH
    ssh_username = "root"
    ssh_password = "redhat123"
    ssh_port     = 22
    ssh_timeout  = "1800s"

    # ISO
    iso_url      = var.boot_iso_url
    iso_checksum = var.boot_iso_checksum

    # Boot
    boot_wait    = "10s"
    boot_command = [
        "<tab>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "quiet text inst.repo=${var.installation_repo} inst.ks=cdrom:/dev/sr1:/ks.cfg<enter><wait>",
    ]

    # Kickstart
    cd_files = ["${path.root}/ks/ks.cfg"]
    cd_label = "cidata"

    # Create VMware template and remove cdrom
    remove_cdrom  = true
    convert_to_template  = true
}
