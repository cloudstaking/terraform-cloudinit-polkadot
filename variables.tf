variable "application_layer" {
  type        = string
  default     = "host"
  description = "You can deploy the Polkadot using docker containers or in the host itself (using the binary)"

  validation {
    condition     = can(regex("^docker|host", var.application_layer))
    error_message = "It can be either \"host\" or \"docker\"."
  }
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "enable_polkashots" {
  default     = false
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "CLI arguments appended to the polkadot service (e.g validator name)"
}

variable "p2p_port" {
  default     = 30333
  type        = number
  description = "P2P port for Polkadot service, used in `--listen-addr` args"
}

variable "proxy_port" {
  default     = 80
  type        = number
  description = "nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS)"
}

variable "public_fqdn" {
  description = "Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node_exporter](https://github.com/prometheus/node_exporter)"
  default     = ""
  type        = string
}

variable "http_username" {
  description = "Username to access endpoints (e.g node_exporter)"
  default     = ""
  type        = string
}

variable "http_password" {
  description = "Password to access endpoints (e.g node_exporter)"
  default     = ""
  type        = string
}

variable "cloud_provider" {
  description = "Some components (like additional volumes) are set up differently between cloud providers"
  type        = string
}

variable "additional_volume" {
  description = "If additional volume is created (mainly from Scaleway and DigitalOcean), set this variable in order to set the volume up (mounted in /home)"
  type        = bool
}
