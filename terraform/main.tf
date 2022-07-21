provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true # to skip ca trust issues
  pm_debug            = true # to debug problem with the client api
}

resource "proxmox_pool" "proxmox_cluster_pool_prod" {
  poolid  = "prod"
  comment = "a pool for all resources that are crucial and up runing"
}

resource "proxmox_pool" "proxmox_cluster_pool_testing" {
  poolid  = "testing"
  comment = "a pool for all temprorary resources"
}

resource "proxmox_vm_qemu" "centos-1" {
  name        = "centos-1"
  desc        = "CentOS Test Server for practicing my linux+ cours"
  vmid        = 201
  target_node = "pve2"
  pool        = "testing"
  iso         = "CentOS-7-x86_64-Minimal-2009.iso"
  oncreate    = true
  sockets     = 1
  cores       = 1
  memory      = 1024
  os_type     = "Linux 5.x - 2.6 Kernel"

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  disk {
    storage = "local-lvm"
    type    = "scsi"
    size    = "4G"
  }
}


resource "proxmox_vm_qemu" "ubuntu-1" {
  name        = "ubuntu-1"
  desc        = "Ubuntu Test Server for practicing my linux+ cours"
  vmid        = 101
  target_node = "pve1"
  agent       = 1
  pool        = "testing"
  clone       = "ubuntu"
  oncreate    = true
  sockets     = 1
  cores       = 1
  memory      = 2048
  full_clone  = true
  os_type     = "Linux 5.x - 2.6 Kernel"
  ipconfig0   = "ip=192.168.1.3/24,gw=192.168.1.254"
  ciuser      = "mehdi"
  sshkeys     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4/yKDpcdKmYEG/qEM5cz+YSGWoSRWgtTf0BioU60D1 Ubuntu proxmox"

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  disk {
    storage = "local-lvm"
    type    = "scsi"
    size    = "4G"
  }
}

# resource "proxmox_lxc" "docker" {
#   count = 3
#   vmid = sum()
#   clone        = "300"
#   full         = true
#   hostname     = "docker8"
#   target_node  = "pve2"
#   unprivileged = true
#   password     = var.proxmox_lxc_password
#   cores        = 1
#   memory       = 1024

#   features {
#     nesting = true
#   }

#   rootfs {
#     storage = "local-lvm"
#     size    = "4G"
#   }

#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "192.168.1.17/24"
#     gw     = "192.168.1.254"
#     ip6    = "dhcp"
#   }
# }
