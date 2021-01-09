
# Packer Build File

variable "box_name" {
    type = string
}

variable "box_version" {
    type = string
}

variable "boot_iso_url" {
    type = string
}

variable "boot_iso_checksum" {
    type = string
}

variable "installation_repo" {
    type = string
}

build {
    sources = ["source.virtualbox-iso.packer-centos-virtualbox"]

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

    # create Vagrant box
    post-processor "vagrant" {
        output = "${path.cwd}/build/{{.Provider}}-${var.box_name}.box"
    }
}

source "virtualbox-iso" "packer-centos-virtualbox" {

    # VM
    vm_name       = "packer-${var.box_name}-x86_64"
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
