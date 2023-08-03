---
title: Linux config for Macbook Pro
tags: [configuration, macbook]
---


## Solve "Possibly missing firmware" during `mkinitcpio`
```
==> WARNING: Possibly missing firmware for module: 'bfa'
==> WARNING: Possibly missing firmware for module: 'qla2xxx'
==> WARNING: Possibly missing firmware for module: 'qed'
==> WARNING: Possibly missing firmware for module: 'qla1280'
```

Debian: [https://packages.debian.org/bullseye/firmware-qlogic](firmware-qlogic)
Arch: [https://archlinux.org/packages/core/any/linux-firmware-qlogic/](linux-firmware-qlogic)

