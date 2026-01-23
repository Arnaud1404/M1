# Cheat sheet
Toujours faire un schéma du réseau sur papier

## Launch VMs (replace X with td num)
    cd /net/stockage/aguermou/AR/TP/X/
    ./qemunet.sh -d tmux -b -t topology -a archive_tpX.tgz

## List config:
    ifconfig -a
    ip addr ls

## Setting up IP
    ifconfig eth0 172.16.0.4/24 
    ip addr add 172.16.0.4/24 dev eth0 brd +

## Config IP at boot time (see `man interfaces`)
    edit /etc/network/interfaces and set static IP

```
iface eth1 inet static
    address 192.168.1.2/24
    gateway 192.168.1.1
```

apply config with `/etc/init.d/networking restart`

## Make broadcasts work
    echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
    ping -b 172.16.0.255

## Routing 
### See routes with `route -n`
### Add defauly gateway entry
`route add default gw 147.210.13.1`

### Specific gateways for each network
In /etc/network/interfaces, execute bash commands 
post-up `route add -net 147.210.13.0/24 gw 147.210.12.2`
post-up `route add -net 147.210.16.0/24 gw 147.210.14.2`

Allow ip forwarding with
`echo "1" > /proc/sys/net/ipv4/ip_forward`

### post-up 
## Debug commands
`tcpdump -i eth0`
`tcpdump -i eth1`


`echo "1" > `
## Exit cleanly
    poweroff

