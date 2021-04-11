#cloud-config

packages:
  - ufw

runcmd:
  - ufw allow OpenSSH
  - ufw allow 'Nginx Full'
  - ufw allow 9100/tcp
  - ufw default deny incoming
  - ufw reload
  - ufw enable

merge_type: 'list(append)+dict(recurse_array)+str()'
