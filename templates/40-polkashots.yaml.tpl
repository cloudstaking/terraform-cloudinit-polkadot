#cloud-config

runcmd:
  - wget https://${chain.short}-rocksdb.polkashots.io/snapshot -O /home/polkadot/${chain.name}.RocksDb.7z
  - cd /home/polkadot && 7z x ${chain.name}.RocksDb.7z -o/home/polkadot/.local/share/polkadot/chains/ksmcc3
  - rm -rf /home/polkadot/${chain.name}.RocksDb.7z
  - %{ if application_layer == "docker" ~} chown 1000:1000 /home/polkadot/ -R %{ else ~} chown polkadot:polkadot /home/polkadot -R %{ endif ~}

merge_type: 'list(append)+dict(recurse_array)+str()'

