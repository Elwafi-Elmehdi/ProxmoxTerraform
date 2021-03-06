variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_lxc_password" {
  type      = string
  sensitive = true
}

variable "proxmox_docker_manager_ips" {
  type        = list(string)
  description = "The IP addresses for docker swarm managers"
  default     = ["192.168.1.25/24", "192.168.1.26/24", "192.168.1.27/24"]
}

variable "proxmox_docker_workers_ips" {
  type        = list(string)
  description = "The IP addresses for docker swarm workers"
  default     = ["192.168.1.28/24", "192.168.1.29/24", "192.168.1.30/24", "192.168.1.31/24", "192.168.1.32/24"]
}

variable "proxmox_network_gateway_ip" {
  type        = string
  description = "The default network gateway ip address"
  default     = "192.168.1.254"
}
