provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true # to skip ca trust issues
  pm_debug            = true # to debug problem with the client api
}

resource "proxmox_vm_qemu" "ubuntu-test-1" {
  name        = "ubuntu-2"
  desc        = "Ubuntu test server terraform init"
  vmid        = 201
  target_node = "pve2"
  agent       = 1
  clone       = "ubuntu"
  
  sockets     = 1
  cores       = 1
  cpu         = "host"
  memory      = 2048
  pool        = "stagging"
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  disk {
    storage = "local-lvm"
    type    = "virtio"
    size    = "8G"
  }
  os_type   = "cloud-init"
  ipconfig0 = "ip=192.168.1.16/24,gw=192.168.1.254"
}
