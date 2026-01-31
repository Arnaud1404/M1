### Scapy
Launch REPL with `scapy`

## Différence entre sr() et sr1()
Les deux fonctions travaillent au niveau 3 (IP).

*   **`sr()`** : Retourne un tuple `(ans, unans)`. `ans` contient les paires (envoyé, reçu).
    *   Exemple : `ans, unans = sr(IP(dst="192.168.0.1")/ICMP())`
    *   Accès réponse : `ans[0][1]`
*   **`sr1()`** : Retourne uniquement le **premier** paquet de réponse reçu.
    *   Exemple : `rep = sr1(IP(dst="192.168.0.1")/ICMP())`
    *   Accès réponse : `rep` (directement le paquet)

## Send ICMP request to 192.168.0.1 (immortal)
https://scapy.readthedocs.io/en/latest/usage.html#send-and-receive-packets-sr

`p = sr1(IP(dst="192.168.0.1")/ICMP()/"bonjour from syl")`

**Encapsulation** :
La fonction `sr1` travaille au niveau 3 (IP). Scapy gère l'encapsulation Ethernet (Niveau 2) via la table de routage.

**Réponse** :
Le paquet envoyé est un *Echo Request*. La réponse reçue (`rep`) sera un *Echo Reply*.

## Sniffing
https://scapy.readthedocs.io/en/latest/usage.html#sniffing

```python
a = sniff(filter="icmp and host 192.168.0.1", count=2)
<Sniffed: TCP:0 UDP:0 ICMP:2 Other:0>

>>> a[1]
<Ether  dst=aa:aa:aa:aa:00:00 src=aa:aa:aa:aa:02:00 type=IPv4 |<IP  version=4 ihl=5 tos=0x0 len=84 id=53062 flags= frag=0 ttl=64 proto=icmp chksum=0x2a0d src=192.168.0.4 dst=192.168.0.1 |<ICMP  type=echo-reply code=0 chksum=0xd2cd id=0x2 seq=0x86 unused=b'' |<Raw  load=b'\xd5\xba|i\x00\x00\x00\x00\x0f\xb3\x0c\x00\x00\x00\x00\x00\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,-./01234567' |>>>>

>>> a[0]
<Ether  dst=aa:aa:aa:aa:02:00 src=aa:aa:aa:aa:00:00 type=IPv4 |<IP  version=4 ihl=5 tos=0x0 len=84 id=15536 flags=DF frag=0 ttl=64 proto=icmp chksum=0x7ca3 src=192.168.0.1 dst=192.168.0.4 |<ICMP  type=echo-request code=0 chksum=0xcacd id=0x2 seq=0x86 unused=b'' |<Raw  load=b'\xd5\xba|i\x00\x00\x00\x00\x0f\xb3\x0c\x00\x00\x00\x00\x00\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,-./01234567' |>>>>
```

## TCP Port 22

```python
ans, unans = sr(IP(dst="192.168.0.1")/TCP(dport=22, flags="S"))

syn_ack = ans[0][1]

# Construction et envoi du ACK
# sport : on reprend le port destination du paquet reçu (qui est notre port source initial)
# seq   : on reprend l'ack du paquet reçu
# ack   : on prend le seq du paquet reçu + 1

## Problème du RST (Reset)
# Si a.summary() affiche un flag "R" (Reset), c'est que le noyau a tué la connexion.
# IP / TCP 192.168.0.1:ssh > 192.168.0.4:ftp_data R / Padding
# Solution : Bloquer les RST sortants du noyau avant de lancer le script.
# iptables -A OUTPUT -p tcp --tcp-flags RST RST -j DROP

# Envoi du ACK final et récupération de la bannière (Data)
a = sr1(IP(dst="192.168.0.1")/TCP(dport=22, sport=syn_ack.dport, seq=syn_ack.ack, ack=syn_ack.seq + 1, flags="A"))

# Affichage de la bannière SSH
print(a.getlayer(Raw).load)
# Résultat attendu : b'SSH-2.0-OpenSSH_10.0p2 Debian-8\r\n'
```

## Pourquoi je n'ai pas de Shell ?
Scapy a établi le canal de transport (TCP), mais pas la session applicative (SSH).
Le protocole SSH nécessite ensuite de la cryptographie (échange de clés, chiffrement) que Scapy ne gère pas nativement.

Pour obtenir la vraie connexion :
`ssh root@192.168.0.1` (dans un terminal standard)

## Implémentation d'un Traceroute
Le principe est d'envoyer des paquets avec un **TTL incrémental**.
*   TTL=1 : Le premier routeur jette le paquet et répond ICMP Time Exceeded (Type 11).
*   TTL=2 : Le deuxième routeur répond...
*   Destination atteinte : Réponse ICMP Echo Reply (Type 0).

```python
target = "192.168.0.1"
ECHO_REPLY = 0
TTL_EXCEEDED = 11

for i in range(1, 30):
    packet = IP(dst=target, ttl=i)/ICMP()
    reply = sr1(packet)
    
    if reply is None:
        print(f"{i}: *")
    elif reply.type == TTL_EXCEEDED:
        print(f"{i}: {reply.src}")
    elif reply.type == ECHO_REPLY:
        print(f"{i}: {reply.src} (Reached)")
        break
```

## Telnet sniffing

Scénario : Une victime se connecte en Telnet (non chiffré).
L'attaquant écoute le réseau.

```python
def process_packet(packet):
    """Afficher les données"""
    if packet.haslayer(Raw):
        # On affiche le contenu décodé (ou brut)
        print(packet[Raw].load)

# Lancer le sniff sur le port 23
# prn : fonction appelée à chaque paquet capturé
sniff(filter="tcp port 23", prn=process_packet, store=0)
```

> Lancer avec telnet 192.168.0.2