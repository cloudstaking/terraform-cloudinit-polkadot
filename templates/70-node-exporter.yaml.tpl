#cloud-config

apt:
  sources:
    caddy-stable.list:
      source: deb https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v2

        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
        A5zVwuXbvH6GHaZJVHUrII6w8rjimo5r
        =e4lF
        -----END PGP PUBLIC KEY BLOCK-----

packages:
  - prometheus-node-exporter
  - caddy

write_files:
- path: /etc/default/prometheus-node-exporter
  content: |
    ARGS="--web.listen-address=\":9200\""
  owner: root:root
  permissions: '0644'
- path: /etc/caddy/Caddyfile
  content: |
    ${public_domain}:9100 {
      reverse_proxy 127.0.0.1:9200
      basicauth {
        ${http_username} ${http_password} 
      }
      log
    }
  owner: root:root
  permissions: '0644'

merge_type: 'list(append)+dict(recurse_array)+str()'
