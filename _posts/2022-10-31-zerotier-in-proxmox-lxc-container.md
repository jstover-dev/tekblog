---
title: Enable ZeroTier in an Proxmox Unprivileged LXC container
tags: [sysadmin, proxmox, lxc, zerotier]
---

_Credit to `james.tervit` on the ZeroTier forums:_
[https://discuss.zerotier.com/t/enabling-zerotier-6-4-proxmox-6-4-4-lxc-containerw/3043](https://discuss.zerotier.com/t/enabling-zerotier-6-4-proxmox-6-4-4-lxc-containerw/3043)
([Archived](http://web.archive.org/web/20210623173801/https://discuss.zerotier.com/t/enabling-zerotier-6-4-proxmox-6-4-4-lxc-containerw/3043))


When running ZeroTier inside an unprivileged container, the `PORT_ERROR` status is shown when running `zerotier-cli listnetworks`:
```
# zerotier-cli listnetworks
200 listnetworks <nwid> <name> <mac> <status> <type> <dev> <ZT assigned ips>
200 listnetworks xxxxxxxxxxxxxxxx networkname XX:XX:XX:XX:XX:XX PORT_ERROR PRIVATE 172.22.62.148/16
```

This is due to the lack of permissions required for ZeroTier to create the tunnel interface.
Printing all network in
Displaying all links shows that there is no `zt` interface:
```sh
# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0@if357: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether aa:bb:cc:dd:ee:ff brd ff:ff:ff:ff:ff:ff link-netnsid 0
```

To allow the container to create a tunnel interface, the TUN/TAP device on the host can be mounted inside the container.

---

With the container stopped, SSH into the Proxmox host and edit the container's configuration file.

Configuration files are located in `/etc/pve/lxc` and are named after the proxmox ID, so assuming the container ID is `100`:

```sh
sudo vim /etc/pve/lxc/100.conf
```

Add the following line:
```
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```

Then reboot the container.

---

Interface now exists:
```sh
# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0@if357: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether aa:bb:cc:dd:ee:ff brd ff:ff:ff:ff:ff:ff link-netnsid 0
3: zt2lrtzih6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2800 qdisc pfifo_fast state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 11:22:33:44:55:66 brd ff:ff:ff:ff:ff:ff
```

ZeroTier no longer has an error status:
```sh
# zerotier-cli listnetworks
200 listnetworks <nwid> <name> <mac> <status> <type> <dev> <ZT assigned ips>
200 listnetworks xxxxxxxxxxxxxxxx networkname XX:XX:XX:XX:XX:XX OK PRIVATE zt2lrtzih6 172.22.62.148/16
```

