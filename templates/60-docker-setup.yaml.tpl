#cloud-config

write_files:
- path: /home/polkadot/nginx.conf
  content: |
    user              nginx;
    worker_processes  auto;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;

    events {
            worker_connections 1024;
    }

    stream {
            # Specifies the main log format.
            log_format stream '\$remote_addr [\$time_local] \$status "\$connection"';

            access_log /dev/stdout stream;

            server {
                    listen 0.0.0.0:${proxy_port};
                    proxy_pass validator:30333;
            }
    }
  owner: root:root
  permissions: '0644'
- path: /home/polkadot/docker-compose.yml
  content: |
    version: "3.3"

    services:
      validator:
        image: parity/polkadot:${latest_version}
        container_name: validator
        restart: unless-stopped
        ports:
          - 30333:30333
          - 9933:9933
          - 9944:9944
          - 9615:9615
        volumes:
          - /home/polkadot/.local/share/polkadot:/polkadot/.local/share/polkadot
        command: ${additional_common_flags}
        networks:
          - default

      nginx:
        container_name: nginx
        image: nginx:1.19-alpine
        ports:
          - ${proxy_port}:${proxy_port}
          - 9100:9100
        volumes:
          - /home/polkadot/nginx.conf:/etc/nginx/nginx.conf
        networks:
          - default

    networks:
      default:
  owner: root:root
  permissions: '0644'

runcmd:
  - export PUBLIC_IP=$(curl 'https://api.ipify.org') && sed -i "s/PUBLIC_IP_ADDRESS/$PUBLIC_IP/g" /home/polkadot/docker-compose.yml

merge_type: 'list(append)+dict(recurse_array)+str()'
