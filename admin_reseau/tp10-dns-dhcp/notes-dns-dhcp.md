# DNS

[Notes du prof](https://aurelien-esnard.emi.u-bordeaux.fr/wiki/doku.php?id=admin:tp8)

tcpdump __-n__ pour interdire les reauetes DNS inverses

Lancer le serveur avec `/etc/init.d/bind9 restart`

Infos avec 
```
 named-checkzone 0.168.192.in-addr.arpa db.0.168.192
 named-checkzone metal.fr db.metal
 named-checkconf -z
```

Test avec `dig nile.metal.fr`

Check logs dans `/var/log/syslog`
## /etc/bind/named.conf.local
```
// Goal: ping opeth.metal.fr
zone "metal.fr" {
        type master;
        file "/etc/bind/db.metal";
};

// Reverse DNS
zone "0.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/db.0.168.192";
};
```

## /etc/bind/db.metal
```
$TTL    86400
@       IN      SOA     dns1.metal.fr mailer.metal.fr. (
                              1         ; Serial
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      immortal
@       IN      MX      10      nile

immortal        IN      A       192.168.0.2
syl             IN      A       192.168.0.1
nile            IN      A       192.168.0.3

; alias
mailer          IN      CNAME   nile ; Serveur Mail
dns1            IN      CNAME   immortal ; Serveur DNS

```

## Config client
Config Client DNS

Dans /etc/resolv.conf :

```
search metal.fr
nameserver 192.168.0.2
```
Dans /etc/nsswitch.conf :
```
...
hosts:          files dns
...
```
Ne pas oublier de redémarrer le daemon nscd
`systemctl restart nscd`