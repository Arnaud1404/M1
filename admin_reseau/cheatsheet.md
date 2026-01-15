# Cheat sheet
## Launch VMs
    cd /net/stockage/aguermou/AR/TP/1/
    ./qemunet.sh -d tmux -b -t topology -a archive_tp1.tgz
## List config:
    ifconfig -a
    ip addr ls

## Setting up IP
    ifconfig eth0 172.16.0.4/24 
    ip addr add 172.16.0.4/24 dev eth0 brd +


## Config IP at boot time (see `man interfaces`)
    edit /etc/network/interfaces and set static IP

## Make broadcasts work
    echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
    ping -b 172.16.0.255

## Exit cleanly
    poweroff

