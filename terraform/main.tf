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

resource "proxmox_vm_qemu" "ubuntu-1" {
  name        = "ubuntu-1"
  desc        = "Ubuntu test server terraform init"
  vmid        = 101
  target_node = "pve1"
  agent       = 1
  clone       = "ubuntu"
  oncreate    = true
  sockets     = 1
  cores       = 1
  cpu         = "host"
  memory      = 2048
  full_clone  = true
  os_type     = "cloud-init"
  ipconfig0   = "ip=192.168.1.16/24,gw=192.168.1.254"
  ciuser      = "mehdi"
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  disk {
    storage = "local-lvm"
    type    = "scsi"
    size    = "8G"
  }
}

resource "proxmox_lxc" "docker8" {
  vmid         = 304
  clone        = "300"
  full         = true
  hostname     = "docker8"
  target_node  = "pve2"
  unprivileged = true
  password     = var.proxmox_lxc_password
  cores        = 1
  memory       = 1024

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
    ip     = "192.168.1.17/24"
    gw     = "192.168.1.254"
    ip6    = "dhcp"
  }
}
