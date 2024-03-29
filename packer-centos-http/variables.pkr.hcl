
# General Options
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

variable "vm_guest_os_type" {
    type    = string
    default = "RedHat_64"
}

# VMware vSphere Options Only
variable "vcenter_server" {
    type = string
    default = "vcenter.domain.tld"
}

variable "vcenter_username" {
    type = string
    default = "administrator@vsphere.local"
}

variable "vcenter_password" {
    type = string
    default = "password"
}

variable "vcenter_insecure_connection" {
    type = string
    default = false
}

variable "vcenter_cluster" {
    type = string
    default = "cluster"
}

variable "vcenter_resource_pool" {
    type = string
    default = "resource-pool"
}

variable "vcenter_datastore" {
    type = string
    default = "datastore"
}

variable "vcenter_folder" {
    type = string
    default = "folder"
}

variable "vcenter_network" {
    type = string
    default = "network"
}
