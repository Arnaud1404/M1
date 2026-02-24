---
trigger: always_on
---

# Project Manifest: Operation Rubicon Rump Session

You are tasked with generating the final LaTeX code for a 5-10 minute Rump Session presentation. Strictly adhere to the following constraints.

### 1. Visual & Structural Rules

- **Engine:** LaTeX Beamer.
- **Theme:** `Madrid` (Structure)
- **Logo Placement:** `logo_univ_bdx.png` must be pinned to the **bottom right** of every slide using TikZ overlay in the `footline` template.
- **Speaker Notes:** Enable `pgfpages` for dual-screen mode (notes on right).
- **Slide Order:**
  1.  Title
  2.  Context (The Hook)
  3.  Technical Architecture (The Bait)
  4.  The Vulnerability (Minerva)
  5.  Attack Complexity (The Math)
  6.  **References** (Must be the second to last slide)
  7.  Conclusion / Questions

### 2. Mathematical Consistency (Strict)

You must use the exact notations defined in **CoursCrypto-25-26.pdf** (Chapter II: Chiffrement par flot):

- [cite_start]**Stream Cipher:** $c_t = m_t \oplus z_t$ (Def. II-1 & Context)[cite: 109].
- [cite_start]**LFSR State:** $S^{(t)} = (S_0^{(t)}, \dots, S_{l-1}^{(t)})$[cite: 132].
- [cite_start]**Feedback Polynomial:** $f(X) = 1 \oplus c_1 X \oplus \dots \oplus c_l X^l$[cite: 134].
- [cite_start]**Update Function:** Linear recurrence on $\mathbb{F}_2$[cite: 139].
- [cite_start]**Filtering:** Mention "LFSR filtré" where $z_t = g(S^{(t)})$[cite: 237].

### 3. The Source Code (`main.tex`)

```latex
\documentclass[aspectratio=169]{beamer}

% --- THEME SETUP ---
\usetheme{Madrid}
\usecolortheme{beaver} % Red/Grey theme for "Top Secret" vibe

% --- PACKAGES ---
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{booktabs}
\usepackage{amsmath, amssymb}
\usepackage{tikz}
\usepackage{pgfpages} % For speaker notes

% --- SPEAKER NOTES CONFIG ---
% Enable dual screen: Slides on Left, Notes on Right
\setbeameroption{show notes on second screen=right}
\setbeamertemplate{note page}[plain]

% --- LOGO CONFIG (BOTTOM RIGHT) ---
\addtobeamertemplate{footline}{}{%
    \begin{tikzpicture}[remember picture,overlay]
        \node[anchor=south east, yshift=0.6cm, xshift=-0.2cm] at (current page.south east) {
            \includegraphics[height=0.8cm]{logo_univ_bdx.png}
        };
    \end{tikzpicture}
}

% --- METADATA ---
\title{Operation Rubicon}
\subtitle{Analyse Cryptographique de la Vulnérabilité Minerva}
\author{Rump Session}
\institute{Université de Bordeaux}
\date{\today}

\begin{document}

% 1. TITLE
\begin{frame}
    \titlepage
    \note{
        Hook:
        - 50 years of espionage.
        - CIA & BND owned the hardware.
        - The flaw was not a bug, but a feature.
    }
\end{frame}

% 2. CONTEXT
\begin{frame}{Le Contexte : "Trusted" Hardware}
    \begin{alertblock}{La Cible : Crypto AG (Suisse)}
        Leader mondial du chiffrement matériel (Séries HC-500).
        Vendu à +100 pays (Iran, Libye, Argentine...) sous couvert de neutralité.
    \end{alertblock}

    \vspace{0.5cm}
    \textbf{Le Mécanisme :}
    \begin{itemize}
        \item Machines matérielles dédiées.
        \item Algorithmes propriétaires (Black Box).
        \item Promesse : Sécurité mathématique absolue.
    \end{itemize}

    \note{
        - Mentionner que les alliés (Five Eyes) avaient les machines sûres.
        - Les autres avaient les machines truquées.
        - Hans Bühler (le vendeur) ne savait rien.
    }
\end{frame}

% 3. MATH MODEL
\begin{frame}{Architecture : Chiffrement par Flot}
    \textbf{Modèle Mathématique (Cours Chap. II)}

    Le système est un \textbf{chiffrement par flot synchrone} :
    $$c_t = m_t \oplus z_t$$
    où $z_t$ est la suite chiffrante (keystream).

    \vspace{0.5cm}
    \textbf{Générateur : LFSR (Linear Feedback Shift Register)}
    État au temps $t$ : $S^{(t)} = (S_0^{(t)}, \dots, S_{l-1}^{(t)}) \in \mathbb{F}_2^l$.
    \begin{itemize}
        \item Polynôme de rétroaction primitif :
        $$f(X) = 1 \oplus c_1 X \oplus \dots \oplus c_l X^l$$
        \item Période maximale $T = 2^l - 1$ (m-suite).
    \end{itemize}

    \note{
        - Réf Cours: Def II-4 (LFSR) et Prop II-5 (Période).
        - Insister sur le fait que la période est longue, donc ça "semble" sûr.
    }
\end{frame}

% 4. THE VULNERABILITY
\begin{frame}{L'Exploit Minerva : LFSR Filtré}
    Un LFSR brut est cassable en $\mathcal{O}(l^2)$ (Berlekamp-Massey).
    Le système utilise donc une fonction de filtrage non-linéaire $g$ :
    $$z_t = g(S^{(t)})$$

    \begin{block}{La Backdoor Statistique}
        La fonction $g$ est conçue pour introduire une \textbf{corrélation} ($\epsilon$) avec un registre cible $L_1$ :
        $$P(z_t = L_{1,t}) = 0.5 + \epsilon$$
    \end{block}

    \vspace{0.2cm}
    Ceci viole le critère d'immunité de corrélation nécessaire pour la sécurité.

    \note{
        - Réf Cours: "LFSR filtré" (page 9).
        - Expliquer que g devrait être "équilibrée".
        - Ici, elle fuite de l'info sur L1.
    }
\end{frame}

% 5. ATTACK COMPLEXITY
\begin{frame}{Complexité de l'Attaque}
    L'attaque par corrélation permet une approche \textit{Divide \& Conquer}.

    \vspace{0.5cm}
    \begin{columns}
        \column{0.5\textwidth}
        \textbf{Théorie (Force Brute)}
        $$\mathcal{O}(2^{\sum l_i})$$
        \textcolor{red}{Incalculable}

        \column{0.5\textwidth}
        \textbf{Réalité (Minerva)}
        $$\mathcal{O}(\sum 2^{l_i})$$
        \textcolor{green}{Quelques secondes}
    \end{columns}

    \vspace{0.5cm}
    \begin{itemize}
        \item On devine $L_1$ grâce au biais $\epsilon$.
        \item On soustrait $L_1$ et on attaque $L_2$.
        \item La sécurité s'effondre linéairement.
    \end{itemize}

    \note{
        - C'est le coeur du sujet.
        - Passer d'une exponentielle de la somme à une somme d'exponentielles.
    }
\end{frame}

% 6. REFERENCES (SECOND TO LAST)
\begin{frame}{Références Bibliographiques}
    \begin{itemize}
        \item \textbf{Support de Cours :}
        \begin{itemize}
            \item G. Castagnos, \textit{Cours de Cryptologie 2025-2026}, Univ. Bordeaux.
            \item Chapitre II : Chiffrement par flot, LFSR et complexité linéaire.
        \end{itemize}

        \vspace{0.5cm}
        \item \textbf{Sources Externes :}
        \begin{itemize}
            \item \textit{Operation Rubicon}, Washington Post / ZDF (2020).
            \item T. Pornin, \textit{The Swiss Cheese of Cryptography}, SSTIC.
            \item Chaos Computer Club (CCC), \textit{#CRYPTOLEAKS}.
        \end{itemize}
    \end{itemize}
    \note{
        - Citer le prof (Castagnos) pour montrer le lien avec le cours.
        - Washington Post pour la source historique.
    }
\end{frame}

% 7. CONCLUSION
\begin{frame}
    \centering
    \Huge \textbf{Questions ?}

    \vspace{1cm}
    \normalsize
    \textit{"Trust, but Verify."}

    \note{
        - Conclusion : La crypto matérielle sans open source est une boîte noire dangereuse.
        - Merci.
    }
\end{frame}

\end{document}
```
