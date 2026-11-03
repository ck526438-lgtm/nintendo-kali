# Nintendo sur Kali Linux 🎮

Script d'installation d'un pack retro Nintendo complet sur **Kali Linux / Debian** (PC dédié ou double boot).

## Consoles couvertes

| Console | Émulateur |
|---|---|
| NES, SNES, Game Boy / Color | RetroArch (cores Nestopia, Snes9x, Gambatte) |
| Game Boy Advance | RetroArch (core mGBA) + mGBA standalone |
| Nintendo 64 | RetroArch (core Mupen64Plus-Next) |
| GameCube + Wii | Dolphin |
| Nintendo DS | melonDS |

Tout passe par **Flatpak**, sans ajouter de repos exotiques qui pourraient casser Kali.

## Jouer au clavier 🌨️

`configure-keyboard.sh` est lance automatiquement par l'installeur (et relancable a volonte). Il ecrit un bloc `NINTENDO-KALI KEYBOARD` dans la config RetroArch avec ce mappage :

| Touche | Fonction | | Touche | Fonction |
|---|---|---|---|---|
| Flèches | Direction / stick gauche | | Q / E | L / R |
| X | Bouton A | | T / Y | L2 / R2 |
| Z | Bouton B | | Entrée | Start |
| A / S | Y / X | | Espace | Select |
| I / J / K / M | C-stick N64 | | F1 | Menu RetroArch |

Pour Dolphin (GameCube/Wii) et melonDS (DS), le script affiche le meme tableau a reproduire dans leurs menus de configuration des commandes. Les manettes branchees restent prioritaires : RetroArch les bascule automatiquement.

## Installation

```bash
git clone https://github.com/ck526438-lgtm/nintendo-kali.git
cd nintendo-kali
bash install-nintendo-kali.sh
```

Lance le script avec ton utilisateur normal (pas root), pas besoin de `chmod` au préalable.

## Après l'installation

1. **RetroArch** → `Online Updater` → `Core Downloader` → installe les cores listés ci-dessus, puis `Update All` + `Rebuild Database`.
2. Place tes jeux dans `~/Jeux-Nintendo/<console>/`.
3. **DS** : copie tes `bios7.bin`, `bios9.bin` et `firmware.bin` dans `~/.var/app/org.melonds.melonds/config/melonDS/`.
4. **GameCube/Wii** : Dolphin télécharge son firmware lui-même au premier lancement.

## Avertissement légal

Utilise uniquement des ROMs, BIOS et firmware copiés depuis **tes propres cartouches et consoles**. Le téléchargement de jeux que tu ne possèdes pas est illégal. Ce dépôt ne fournit aucun jeu ni BIOS.

## Note

Kali Linux est une distro de pentest, pas une distro gaming. Le rétro 8/16-bit, la N64 et la DS tournent très bien ; pour la GameCube/Wii une distro gaming (Bazzite, Fedora Games, SteamOS) sera plus confortable.
