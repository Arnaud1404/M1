# Opération Rubicon : La Vulnérabilité Minerva

## 1. Le Modèle Légitime : Chiffrement par flot
[cite_start]Les machines Crypto AG historiques utilisaient un chiffrement par flot, conçu comme une version pratique du chiffrement de Vernam (masque jetable)[cite: 108].
* [cite_start]**Principe :** À partir d'une clef secrète, on crée de manière déterministe une suite pseudo-aléatoire $(z_k)_{k \in \mathbb{N}}$, appelée suite chiffrante[cite: 108].
* [cite_start]**Opération :** Le texte clair $(m_k)$ est chiffré bit par bit via un XOR additif : $c_k = m_k \oplus z_k$[cite: 109].
* [cite_start]**Avantage :** Faible complexité matérielle et traitement à la volée, idéal pour les communications matérielles de type télex[cite: 110, 112].

## 2. Le Moteur (Le Leurre) : LFSR
Pour générer cette suite, le système s'appuie sur des Registres à Décalage à Rétroaction Linéaire (LFSR).
* **Architecture :** Un automate composé d'un registre de $l$ bits. [cite_start]Le bit entrant est une fonction linéaire des états précédents[cite: 131, 138].
* [cite_start]**Mathématiques :** La rétroaction est définie par un polynôme sur $\mathbb{F}_2[X]$ de degré $l$ : $f(X) = 1 \oplus c_1 X \oplus \dots \oplus c_l X^l$[cite: 133, 134]. [cite_start]L'équation de mise à jour est : $S_{l-1}^{(t+1)} = c_1 S_{l-1}^{(t)} \oplus \dots \oplus c_l S_0^{(t)}$[cite: 139].
* [cite_start]**L'illusion de sécurité :** En utilisant un polynôme de rétroaction *primitif*, la suite générée atteint une période maximale $T = 2^l - 1$ (m-suite)[cite: 150]. [cite_start]Cette m-suite est statistiquement parfaite : elle est équilibrée (le nombre de 0 et de 1 diffère au plus de 1 sur une période)[cite: 183, 185], ce qui trompait les tests statistiques des clients.

## 3. L'Exploit : Le Filtre Compromis
Un LFSR pur n'est pas sûr. [cite_start]La connaissance de $2l$ bits de la suite chiffrante permet de retrouver le polynôme en inversant un système linéaire $l \times l$[cite: 212]. Crypto AG utilisait donc des combinaisons de LFSR passées dans des fonctions non linéaires.
* **La Backdoor :** La NSA/BND truquait la fonction booléenne combinatoire. Au lieu d'avoir une corrélation nulle ($P = 0.5$) entre la sortie globale et l'état interne d'un registre individuel, ils introduisaient un biais statistique $\epsilon$.
* **La Réduction de Complexité (Divide & Conquer) :** Grâce à ce biais, l'attaquant n'a pas à faire une recherche exhaustive sur la combinaison de tous les registres (incalculable). Il peut isoler et deviner l'état d'un registre de longueur $l_1$ de manière indépendante (en temps $\mathcal{O}(2^{l_1})$), puis soustraire sa contribution pour attaquer le registre suivant.
* **Conclusion :** Ce qui était vendu comme une sécurité impénétrable en $\mathcal{O}(2^{l_{total}})$ s'effondrait en une attaque linéaire $\mathcal{O}(\sum 2^{l_i})$.

## 4. Vulnérabilité Périphérique : L'Initialisation
[cite_start]Un chiffrement par flot moderne nécessite un Vecteur d'Initialisation (IV) pour produire des suites différentes avec une même clef[cite: 118].
* [cite_start]**L'implémentation Rubicon :** La fonction dérivant l'état initial $S_0 = h(k, IV)$ [cite: 121] était déterministe et mathématiquement inversible pour quiconque possédait les constantes de conception de la NSA. L'interception de l'IV en clair permettait de remonter à la clef $k$.
