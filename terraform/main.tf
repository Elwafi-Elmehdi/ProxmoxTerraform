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

# resource "proxmox_vm_qemu" "ubuntu-1" {
#   name        = "ubuntu-1"
#   desc        = "Ubuntu Test Server for practicing my linux+ cours"
#   vmid        = 101
#   target_node = "pve1"
#   agent       = 1
#   pool        = "testing"
#   clone       = "ubuntu"
#   oncreate    = true
#   sockets     = 1
#   cores       = 1
#   memory      = 2048
#   full_clone  = true
#   os_type     = "Linux 5.x - 2.6 Kernel"
#   ipconfig0   = "ip=192.168.1.3/24,gw=192.168.1.254"
#   ciuser      = "mehdi"
#   sshkeys     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4/yKDpcdKmYEG/qEM5cz+YSGWoSRWgtTf0BioU60D1 Ubuntu proxmox"

#   network {
#     bridge = "vmbr0"
#     model  = "virtio"
#   }
#   disk {
#     storage = "local-lvm"
#     type    = "scsi"
#     size    = "8G"
#   }
# }
resource "proxmox_lxc" "proxmox_lxc_docker_manager" {
  count        = length(var.proxmox_docker_manager_ips)
  vmid         = sum([401, count.index])
  clone        = count.index <= 1 ? "400" : "300"
  target_node  = count.index <= 1 ? "pve1" : "pve2"
  unprivileged = true
  onboot       = true
  password     = var.proxmox_lxc_password
  cores        = 1
  full         = true
  memory       = 1024
  pool         = "prod"
  hostname     = "dockermgr-${count.index}"

  features {
    nesting = true
  }
  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = var.proxmox_docker_manager_ips[count.index]
    gw     = var.proxmox_network_gateway_ip
    ip6    = "auto"
  }
}