### Feuille de Révision : TP 8 - SSH & Tunnels

**1. Authentification par Clés Asymétriques**
*   **Générer les clés :** Sur le client, tapez `ssh-keygen` pour créer la clé privée (`id_rsa`) et publique (`id_rsa.pub`).
*   **Autoriser la connexion :** Copiez la clé publique sur le serveur et ajoutez-la au fichier des clés autorisées avec `cat id_rsa.pub >> ~/.ssh/authorized_keys`.

**2. Alias SSH et Rebond (~/.ssh/config)**
Pour simplifier les connexions et traverser une passerelle, éditez le fichier `~/.ssh/config` :
```text
Host example
    Hostname addr_immortal
    User username

Host example2
    Hostname addr_grave
    User username
    ProxyJump example 
```

**3. Les Tunnels SSH (Transfert de port)**
*   **Tunnel Local (-L) :** Contourner un pare-feu pour joindre un service interne bloqué.
    `ssh -N -f -L 5555:addr_dt:23 <username>@addr_immortal`.
    *Test :* `telnet localhost 5555`.

*   **Tunnel Distant (-R) :** Exposer un service local (ex: serveur web en développement) à l'extérieur.
    `ssh -N -f -R 5555:localhost:23 <username>@addr_immortal`.
    *Prérequis vital :* Activer `GatewayPorts yes` dans `/etc/ssh/sshd_config` sur le serveur pivot et redémarrer SSH.

*   **Tunnel Dynamique (-D) :** Créer un proxy SOCKS générique.
    `ssh -f -N -D 8080 <username>@addr_immortal`.
    *Utilisation :* Configurez le port dans `/etc/proxychains.conf` ou lancez `PROXYCHAINS_SOCKS5=8080 proxychains <cmd>` pour encapsuler le trafic de n'importe quelle application.
