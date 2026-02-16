# IPV6

## Config
### ifconfig
```bash
ifconfig eth0 inet6 add 2001:db8:0:f101::6/64
ifconfig eth0 up
```
### ip
```bash
ip -6 addr add 2001:db8:0:f101::6/64 dev eth0
ip link set eth0 up
```
### /etc/network/interfaces
```bash
auto eth0
iface eth0 inet6 static
    address 2001:db8:0:f101::6/64
    # ou :
    # address 2001:db8:0:f101::6
    # netmask 64
```

## Sniffing
1. **Écoute (Sur opeth/immortal) :**
   `tcpdump -i eth0 -n -e icmp6`
   *(Option `-e` indispensable pour voir les MACs)*
s
2. **Action (Depuis atg) :**
   `ping6 2001:db8:0:f101::2`

#### 1. La Demande : Neighbor Solicitation (NS)
* **Message :** "Qui possède cette IP ?"
* **IP Destination :** **Multicast Sollicité** (*Solicited-Node*).
  * Format : `ff02::1:ff:xx:xx:xx` (les 24 derniers bits de l'IP cible).
* **MAC Destination :** **Multicast IPv6**.
  * Format : `33:33:ff:xx:xx:xx`.

#### 2. La Réponse : Neighbor Advertisement (NA)
* **Message :** "C'est moi, voici mon adresse MAC."
* **Direction :** Unicast (directement vers l'émetteur).