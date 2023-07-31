---
title: Automount a filesystem using systemd
tags: [sysadmin, configuration]
---

Filename **must** be named based on the mount path

# Automount unit
```
# mnt-mymount.automount

[Unit]
Description=Automount My Mount 

[Automount]
Where=/mnt/mymount

[Install]
WantedBy=multi-user.target
```

# Mount units


## Local disk
```
# backup-usb.mount

[Unit]
Description=Mount backups USB

[Mount]
What=/dev/disk/by-uuid/12345678-aaaa-bbbb-cccc-dddddddddddd
Where=/backup/usb
Type=ext4
Options=defaults,noauto,nofail,user

[Install]
WantedBy=multi-user.target
```

## Samba / Windows


```
# mnt-mymount.mount
[Unit]
Description=MyMount
Requires=systemd-networkd.service
After=network-online.target
Wants=network-online.target

[Mount]
What=//samba.example.com/data
Where=/mnt/mymount
Options=credentials=/root/.smbpasswd,iocharset=utf8,rw,x-systemd.automount,uid=1000
Type=cifs
TimeoutSec=30

[Install]
WantedBy=multi-user.target
```


## SSH

```
# mnt-mymount.mount

[Unit]
Description=MyMount
Requires=systemd-networkd.service
After=network-online.target
Wants=network-online.target

[Mount]
What=user@hostname:/path/to/data
Where=/mnt/mymount
Type=fuse.sshfs
Options=allow_other,uid=1000,gid=1000,IdentityFile=/root/.ssh/id_ed25519

[Install]
WantedBy=multi-user.target
```

