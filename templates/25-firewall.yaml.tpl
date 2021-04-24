#cloud-config

packages:
  - ufw

runcmd:
  - ufw allow OpenSSH
  - ufw allow 80
  - ufw allow 443
  - ufw allow 9100/tcp
  - ufw allow 9616/tcp
  - ufw default deny incoming
  - ufw reload
  - ufw enable

merge_type: 'list(append)+dict(recurse_array)+str()'
