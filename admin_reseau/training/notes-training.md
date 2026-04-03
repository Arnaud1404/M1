# Entrainement TP Noté

# Partie 1 - Fix de réseau
**Objectif:** 
Toutes les machines doivent pouvoir être ping 2 à 2

Diagnostiquer toutes les erreurs et donner le fix **minimal** en **CLI**

**Tips**
Au début, faire schéma topology avec les ip et interfaces

check ip a, route -n; iptables -L -v; iptables -t nat -L -v

check l'ip forwarding

**Issues**
atg manque la route pour comm avec le réseau local
Fix: `route add -net 147.210.20.0/24 dev eth0`

opeth: genmask erroné
Fix:
```
route del -host 147.210.20.0/32
route add -net 147.210.20.0/24 dev eth1
```
iptables en FORWARD DROP
Fix:
`iptables -P FORWARD ACCEPT`

immortal:
les ip de eth1 et eth2 sont inversées
Fix:
```
ifconfig eth1 172.168.0.1/24
ifconfig eth2 192.168.0.1/24
```
et fix la table de routage
`route add default gw 193.50.110.2`

dt typo dans la table de routage
Fix:
```
route del -net 147.61.0.0/24
route add -net 147.16.0.0/24 dev eth0
```
nile en OUTPUT DROP
Fix:
`iptables -P OUTPUT ACCEPT`

## Partie 2 - Config de services
Config client LDAP, NFS (pas d'espace entre les virgules), DNS