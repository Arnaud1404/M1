## TD2
## Config de sous réseaux
4 réseaux
immortal, grave et syl sont des passerelles (gateway, ip forwarding)

#### Fichier topology   eth0 eth1
HOST debian-AR opeth    s1
HOST debian-AR atg      s1
HOST debian-AR immortal s1   s2
HOST debian-AR grave    s2   s3
HOST debian-AR syl      s3   s4
HOST debian-AR nile     s4

Schéma réseau :
-> eth0 de immortal dans le réseau avec opeth et atg
En propageant les contraintes, on devine sur quelle interface
est liée chaque réseau

## Protocole ARP
Address Resolution Protocol (ARP) = correspondance
addresses MAC (physiques) et addresses IP

Sert à trouver l'addr physique à partir de l'addr IP
ARP WHO HAS 147.210.13.1 ?
Requête broadcast uniquement sur tout le réseau local

Table ARP = Cache des correspondances `arp -n`

ping opeth > grave
à chaque saut, la trame ethernet est update dynamiquement
pour correspondre au réseau local

## Analyse de traffic