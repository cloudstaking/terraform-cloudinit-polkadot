locals {
  chain = {
    kusama   = { name = "kusama", short = "ksm" },
    polkadot = { name = "polkadot", short = "dot" }
    other    = { name = var.chain, short = var.chain }
  }

  polkadot_cli_args = [
    "--validator",
    "--public-addr=/ip4/PUBLIC_IP_ADDRESS/tcp/${var.proxy_port}",
    "--rpc-methods=Unsafe",
    "--chain ${var.chain}",
    var.cloud_provider == "host" ? "--listen-addr=/ip4/127.0.0.1/tcp/${var.p2p_port}" : "",
    var.enable_polkashots ? "--database=RocksDb --unsafe-pruning --pruning=1000" : "",
    var.polkadot_additional_common_flags,
  ]

  http_username = var.http_username != "" ? var.http_username : random_password.http_username.result
  http_password = var.http_password != "" ? var.http_password : random_password.http_password.result
}

resource "random_password" "http_username" {
  length  = 8
  special = false
}

resource "random_password" "http_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


data "cloudinit_config" "validator" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "10-os.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/10-${var.application_layer}-os.yaml")
  }

  # This part is applied when addional volume is added
  dynamic "part" {
    for_each = range(var.additional_volume ? 1 : 0)
    content {
      filename     = "20-fs-${var.cloud_provider}.yaml"
      content_type = "text/cloud-config"
      content      = file("${path.module}/templates/20-fs-${var.cloud_provider}.yaml")
    }
  }

  # Firewall
  part {
    filename     = "25-firewall.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/25-firewall.yaml.tpl")
  }

  # This part is applied when polkashots is enabled
  dynamic "part" {
    for_each = range(var.enable_polkashots ? 1 : 0)
    content {
      filename     = "40-polkashots.yaml"
      content_type = "text/cloud-config"
      content = templatefile("${path.module}/templates/40-polkashots.yaml.tpl", {
        chain             = lookup(local.chain, var.chain, local.chain.other)
        application_layer = var.application_layer
      })
    }
  }

  # This part is applied to generate the docker-compose file when application_layer is docker
  dynamic "part" {
    for_each = range(var.application_layer == "docker" ? 1 : 0)
    content {
      filename     = "60-generate-docker-compose.yaml"
      content_type = "text/cloud-config"
      content = templatefile("${path.module}/templates/60-docker-setup.yaml.tpl", {
        chain                   = var.chain
        enable_polkashots       = var.enable_polkashots
        latest_version          = data.github_release.polkadot.release_tag
        additional_common_flags = join(" ", local.polkadot_cli_args)
        p2p_port                = var.p2p_port
        proxy_port              = var.proxy_port
        cloud_provider          = var.cloud_provider
      })
    }
  }

  # This part is applied to configure polkadot and nginx
  dynamic "part" {
    for_each = range(var.application_layer == "host" ? 1 : 0)
    content {
      filename     = "60-host-setup.yaml"
      content_type = "text/cloud-config"
      content = templatefile("${path.module}/templates/60-host-setup.yaml.tpl", {
        additional_common_flags = join(" ", local.polkadot_cli_args)
        p2p_port                = var.p2p_port
        proxy_port              = var.proxy_port
      })
    }
  }

  # node exporter
  part {
    filename     = "70-node-exporter.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/70-node-exporter.yaml.tpl", {
      public_domain = var.public_fqdn
      http_username = local.http_username
      http_password = base64encode(bcrypt(local.http_password))
    })
  }
}

data "github_release" "polkadot" {
  repository  = "polkadot"
  owner       = "paritytech"
  retrieve_by = "latest"
}