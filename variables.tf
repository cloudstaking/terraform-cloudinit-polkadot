variable "application_layer" {
  description = "How to desploy the application layer, using either docker or the host itself"
  type        = string
  default     = "host"
}

variable "cloud_provider" {
  description = "Some components (like additional volumes) are set up differently between cloud providers"
  type        = string
}

variable "additional_volume" {
  description = "Set this variable in order to create an additional volume (mounted in /home)"
  type        = bool
}

variable "polkadot_additional_common_flags" {
  description = "Application layer - the content of this variable will be appended to the polkadot command arguments"
  type        = string
  default     = ""
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  type        = string
}

variable "enable_polkashots" {
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
  default     = false
}

variable "p2p_port" {
  description = "P2P port for Polkadot service"
  default     = 30333
  type        = number
}

variable "proxy_port" {
  description = "nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (e.g DOS)"
  type        = number
  default     = 80
}

variable "public_fqdn" {
  description = "Public domain for the validator. Useful to serve node_exporter through HTTPs"
  type        = string
  default     = ""
}

variable "http_username" {
  description = "Username to access endpoints (e.g node_exporter)"
  type        = string
  default     = ""
}

variable "http_password" {
  description = "Password to access endpoints (e.g node_exporter)"
  type        = string
  default     = ""
}
