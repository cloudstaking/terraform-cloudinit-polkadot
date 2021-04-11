#cloud-config

packages:
  - nginx

write_files:
- path: /etc/nginx/nginx.conf
  content: |
    user              www-data;
    worker_processes  auto;
    include           /etc/nginx/modules-enabled/*.conf;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;

    events {
            worker_connections 1024;
    }

    stream {
            # Specifies the main log format.
            log_format stream '\$remote_addr [\$time_local] \$status "\$connection"';

            access_log /var/log/nginx/access.log stream;
            error_log /var/log/nginx/error.log;

            server {
                    listen 0.0.0.0:${proxy_port};
                    proxy_pass 127.0.0.1:${p2p_port};
            }
    }
  owner: root:root
  permissions: '0644'

runcmd:
  - systemctl enable polkadot
  - echo "POLKADOT_CLI_ARGS=\"${additional_common_flags}\"" > /etc/default/polkadot
  - export PUBLIC_IP=$(curl 'https://api.ipify.org') && sed -i "s/PUBLIC_IP_ADDRESS/$PUBLIC_IP/g" /etc/default/polkadot

merge_type: 'list(append)+dict(recurse_array)+str()'
