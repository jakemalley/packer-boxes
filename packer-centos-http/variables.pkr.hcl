
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
}

variable "vcenter_username" {
    type = string
}

variable "vcenter_password" {
    type = string
}

variable "vcenter_insecure_connection" {
    type = string
}

variable "vcenter_cluster" {
    type = string
}

variable "vcenter_resource_pool" {
    type = string
}

variable "vcenter_datastore" {
    type = string
}

variable "vcenter_folder" {
    type = string
}

variable "vcenter_network" {
    type = string
}
