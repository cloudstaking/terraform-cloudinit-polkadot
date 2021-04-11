# terraform-cloudinit-polkadot

Cloud-init files to setup Kusama/Polkadot validators. Besides the validator itself it also:

- Optionally pulls latest snapshot from [Polkashots](https://polkashots.io)
- [node exporter](https://github.com/prometheus/node_exporter) with HTTPs to pull node metrics from your monitoring systems. 
- Nginx as a reverse proxy for libp2p
- Support for different deplotments methods: either using docker/docker-compose or deploying the binary itself in the host.

This module used by [terraform-aws-polkadot](https://github.com/cloudstaking/terraform-aws-polkadot), [terraform-gcp-polkadot](https://github.com/cloudstaking/terraform-digitalocean-polkadot), [terraform-scaleway-polkadot](https://github.com/cloudstaking/terraform-scaleway-polkadot) and [terraform-digitalocean-polkadot](https://github.com/cloudstaking/terraform-digitalocean-polkadot)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| cloudinit | 2.2.0 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| cloudinit | 2.2.0 |
| github | n/a |
| random | 3.1.0 |

## Resources

| Name |
|------|
| [cloudinit_config](https://registry.terraform.io/providers/hashicorp/cloudinit/2.2.0/docs/data-sources/config) |
| [github_release](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/release) |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_volume | If additional volume is created (mainly from Scaleway and DigitalOcean), set this variable in order to set the volume up (mounted in /home) | `bool` | n/a | yes |
| cloud\_provider | Some components (like additional volumes) are set up differently between cloud providers | `string` | n/a | yes |
| application\_layer | You can deploy the Polkadot using docker containers or in the host itself (using the binary) | `string` | `"host"` | no |
| chain | Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io | `string` | `"kusama"` | no |
| enable\_polkashots | Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `false` | no |
| http\_password | Password to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| http\_username | Username to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| p2p\_port | P2P port for Polkadot service, used in `--listen-addr` args | `number` | `30333` | no |
| polkadot\_additional\_common\_flags | CLI arguments appended to the polkadot service (e.g validator name) | `string` | `""` | no |
| proxy\_port | nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS) | `number` | `80` | no |
| public\_fqdn | Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node\_exporter](https://github.com/prometheus/node_exporter) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| clout\_init | Generated clout-init file to be consumed by the instance resource |
| http\_password | Password to access private endpoints (e.g node\_exporter) |
| http\_username | Username to access private endpoints (e.g node\_exporter) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
