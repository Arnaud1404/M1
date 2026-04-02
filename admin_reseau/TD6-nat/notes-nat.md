# TD6 - NAT

[Notes du prof](https://aurelien-esnard.emi.u-bordeaux.fr/wiki/doku.php?id=admin:tp4)

## 1. Static NAT for `mpe` and `opeth`
To allow machines with private addresses to communicate, we modify the source of the packet after routing.

For gateway `dt` (connecting to `opeth` via `eth1` and external via `eth0`):
```bash
iptables -t nat -A POSTROUTING -s <OPETH_IP> -o eth0 -j SNAT --to-source <DT_PUB_IP>
```

For gateway `immortal` (connecting to `mpe` via `eth2` and external via `eth1`):
```bash
iptables -t nat -A POSTROUTING -s <MPE_IP> -o eth1 -j SNAT --to-source <IMMORTAL_PUB_IP>
```

## 2. Display Active Rules
To view the configured rules in the NAT table:
```bash
iptables -t nat -L -v -n
```

## 3. Traffic Analysis (mpe -> atg)
When `mpe` communicates with `atg`:
1.  **At `immortal`:** The packet enters and traverses the routing decision. As it is destined for another network, it goes through FORWARD. In the POSTROUTING chain, the NAT de source is applied. The source IP is rewritten to `immortal`'s public IP.
2.  **At `grave`:** `grave` only sees a packet originating from `immortal`'s public IP.

## 4. Flush NAT Rules
To remove all active NAT rules on both `immortal` and `dt`:
```bash
iptables -t nat -F
```

## 5. Dynamic Masquerading and Port Forwarding
To set up dynamic address translation for the entire `192.168.0.0/24` subnet on `immortal` (exiting via `eth1`):
```bash
iptables -t nat -A POSTROUTING -o eth1 -s 192.168.0.0/24 -j MASQUERADE
```

To expose port 22 (SSH) of the internal machine `syl` to the outside, modify the destination of incoming packets before routing:
```bash
iptables -t nat -A PREROUTING -p tcp -d <IMMORTAL_PUB_IP> --dport 22 -j DNAT --to-destination <SYL_IP>:22
```