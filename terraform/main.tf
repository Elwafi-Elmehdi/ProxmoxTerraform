provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true # to skip ca trust issues
  pm_debug            = true # to debug problem with the client api
}

resource "proxmox_vm_qemu" "ubuntu-1" {
  name        = "ubuntu-1"
  desc        = "Ubuntu test server terraform init"
  vmid        = 101
  target_node = "pve1"
  agent       = 1
  clone       = "ubuntu"
  oncreate    = true
  # hagroup     = "pve-cluster"
  # guest_agent_ready_timeout = 120
  sockets    = 1
  cores      = 1
  cpu        = "host"
  memory     = 2048
  pool       = "stagging"
  full_clone = true
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  disk {
    storage = "local-lvm"
    type    = "scsi"
    size    = "8G"
  }
  os_type   = "cloud-init"
  ipconfig0 = "ip=192.168.1.16/24,gw=192.168.1.254"
}
