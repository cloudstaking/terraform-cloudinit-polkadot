#cloud-config

write_files:
- path: /root/nginx.conf
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
- path: /root/docker-compose.yml
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
        restart: unless-stopped
        ports:
          - ${proxy_port}:${proxy_port}
        volumes:
          - /home/polkadot/nginx.conf:/etc/nginx/nginx.conf
        networks:
          - default
  
      node-exporter:
        image: prom/node-exporter:v1.0.1
        container_name: node-exporter
        restart: unless-stopped
        volumes:
          - /proc:/host/proc:ro
          - /sys:/host/sys:ro
          - /:/rootfs:ro
        command:
          - '--path.procfs=/host/proc'
          - '--path.sysfs=/host/sys'
          - --collector.filesystem.ignored-mount-points
          - "^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)"
        networks:
          - default

      caddy:
        image: caddy:2.1.1-alpine
        container_name: caddy
        restart: unless-stopped
        ports:
          - "9100:9100"
          - "443:443"
        volumes:
          - $PWD/Caddyfile:/etc/caddy/Caddyfile
          - caddy_data:/data
          - caddy_config:/config
        networks:
          - default

    volumes:
      caddy_data:
      caddy_config:

    networks:
      default:
  owner: root:root
  permissions: '0644'
- path: /root/Caddyfile
  content: |
    ${public_domain}:9100 {
      reverse_proxy node-exporter:9100
      basicauth {
        ${http_username} ${http_password} 
      }
      log
    }
  owner: root:root
  permissions: '0644'

runcmd:
  # The line below is because of the addional volume and cloudinit execution order
  - mv /root/docker-compose.yml /root/nginx.conf /root/Caddyfile /home/polkadot
  - export PUBLIC_IP=$(curl 'https://api.ipify.org') && sed -i "s/PUBLIC_IP_ADDRESS/$PUBLIC_IP/g" /home/polkadot/docker-compose.yml
  # Polkadot's UID inside Docker
  - mkdir /home/polkadot/.local/ && chown 1000:1000 /home/polkadot/.local -R

merge_type: 'list(append)+dict(recurse_array)+str()'
