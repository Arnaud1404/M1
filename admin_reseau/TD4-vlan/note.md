# Exo 1 

## Premier pas

pour configurer la machine : 
edit le fichier dans avec ``nano /etc/network/interfaces ``

et mettre (voir fichier topologie pour les address)
```bash

auto eth0
iface eth0 inet static
    address 192.12.0.1/24
    gateway 192.12.0.3
```

```bash

auto eth0
iface eth0 inet static
    address 134.27.0.1/24
    gateway 134.27.0.3
```

et lancer le script `` /etc/init.d/networking restart ``

faire de même pour toutes les machines sauf immortal.

Pour immortal comme elle est la seul à avoir conscience des Vlan sa config est différente des autres, d'après la topology elle possède qu'une seul interface réseau "eth0".
Mais comme elle gère les vlan elle peut quand même posséder 2 adresse ip
voici la config:

```bash
#VLAN 100
auto eth0.100
iface eth0.100 inet static
    address 134.27.0.3/24
    vlan-raw-device eth0

#VLAN 200
auto eth0.200
iface eth0.200 inet static
    address 192.12.0.3/24
    vlan-raw-device eth0
```

Il faut pas oublier d'activer le mode passerelle sur immortal on doit modifier le fichier `` nano /etc/sysctl.d/forward.conf `` et ajouter/changer la valeur de la variable `net.ipv4.ip_forward = 1`

puis redémarrer le service avec ` systemctl restart systemd-sysctl `


Une fois que toutes les machines sont configurés il faut configurer la switch 's1' de tel sorte à ce qu'elle gère les vlan.

pour interagir avec la vlan, aller sur le terminal s1.

pour créer une vlan il faut faire : `vlan/create Num_VLAN`
donc ici on fait ``vlan/create 100  et vlan/create 200``

pour afficher les différentes Vlan on fait la cmd :
`vlan/print` si on veut voir toutes les commandes possibles faire `help`

une fois qu'on a rajouter les différentes vlan il faut indiquer comment on gère la traffic, autrement dit comment tagger ou non les paquets.

```bash
# ça dit que le port 3 de la switch transmet des paquets tagged et qu'il doit pas ajouter de tag
vlan/addport 100 3
vlan/addport 200 3

#dit que les machines sur les port 1 et 2 doivent recevoir un tagged
port/setvlan 2 100
port/setvlan 1 100

```

Pour vérifier que tout c'est bien passer taper les cmd
``vlan/allprint`` ``port/print``

un port peut être en untagged uniquement sur une seul VLAN, ici j'ai fait une erreur en mettant le port 2 dans la vlan 100 au lieu de 200.
il suffit de réecrire le commande de setvlan pour mettre le port au bon endroit sans avoir à supprimer l'ancien.
`port/setvlan 2 200`


normalement on doit avoir 
```bash
0000 DATA END WITH '.'
VLAN 0000
 -- Port 0003 tagged=0 active=1 status=Forwarding
 -- Port 0021 tagged=0 active=1 status=Forwarding
VLAN 0100
 -- Port 0001 tagged=0 active=1 status=Forwarding
 -- Port 0003 tagged=1 active=1 status=Forwarding
VLAN 0200
 -- Port 0002 tagged=0 active=1 status=Forwarding
 -- Port 0003 tagged=1 active=1 status=Forwarding

```

Pour écouter on se place sur la machine immortal et on rentre la commande
```bash
tcpdump -i eth0 -n -w /tmp/log.pcap -s 1500
mv /tmp/log.pcap /mnt/host
```
et aller sur la machine syl et lancer un serveur avec la cmd:
`` nc -l -p 5555 `` utilise le protocole TCP

puis aller sur opeth faire 
`` nc 134.27.0.1 ``

puis echanger quelques mots.

ensuite on retourne sur immortal et on arrête l'écoute puis extrait le fichier et le lis.

La raison pourlaquelle on peut voir ce qui s'est dit entre les deux machines est 

pour configurer s2 :
```bash
vlan/create 100
vlan/create 200

port/setvlan 2 200 #grave
port/setvlan 1 100 #nile


vlan/addport 200 21
vlan/addport 100 21

```

et rajouter dans la switch 1
```bash
vlan/addport 200 21
vlan/addport 100 21
```

pour que le trunck marche il faut mettre le port 21 en tagged dans les deux switch.


pour tester que la switch 2 marche il on peut faire un pring depuis grave vers syl ou nile.

un autre test est de faire un brodcast sur grave et vérifier qu'il y a que opeth et immortal qui répondent cependant il faut activer la réponse au broadcast sur toutes les machines avec la cmd
```bash
 echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
 ping -b 192.12.0.255
 
 ```
