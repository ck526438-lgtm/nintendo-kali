#!/usr/bin/env bash
# Configure le clavier pour jouer sans manette sur le pack nintendo-kali.
# - RetroArch : mappage écrit automatiquement dans sa config (NES/SNES/GB/GBA/N64)
# - Dolphin et melonDS : tableau de mapping + quelques clics dans leur GUI
# A relancer a volonte : le bloc gere remplace l'ancien.
set -euo pipefail

CFG="$HOME/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg"
mkdir -p "$(dirname "$CFG")"
touch "$CFG"

# Supprime un bloc precedemment ecrit par ce script (re-exécutable sans doublons)
if grep -q "# BEGIN NINTENDO-KALI KEYBOARD" "$CFG"; then
  sed -i '/# BEGIN NINTENDO-KALI KEYBOARD/,/# END NINTENDO-KALI KEYBOARD/d' "$CFG"
fi

# Codes RetroArch : lettres = ASCII minuscule, fleches = 273-276, Entree = 13, Espace = 32
cat >> "$CFG" <<'EOF'
# BEGIN NINTENDO-KALI KEYBOARD
input_autodetect_enable = "true"
input_player1_b_btn = "122"
input_player1_y_btn = "97"
input_player1_select_btn = "32"
input_player1_start_btn = "13"
input_player1_up_btn = "273"
input_player1_down_btn = "274"
input_player1_left_btn = "276"
input_player1_right_btn = "275"
input_player1_a_btn = "120"
input_player1_x_btn = "115"
input_player1_l_btn = "113"
input_player1_r_btn = "101"
input_player1_l2_btn = "116"
input_player1_r2_btn = "121"
input_player1_l3_btn = "107"
input_player1_r3_btn = "108"
input_player1_lstick_up = "273"
input_player1_lstick_down = "274"
input_player1_lstick_left = "276"
input_player1_lstick_right = "275"
input_player1_rstick_up = "105"
input_player1_rstick_down = "107"
input_player1_rstick_left = "106"
input_player1_rstick_right = "109"
# END NINTENDO-KALI KEYBOARD
EOF

cat <<'EOF'
================================================================
 CLAVIER - RetroArch (NES/SNES/GB/GBA/N64) : CONFIGURE !
================================================================

  Fleches ............ Direction / analogique gauche
  X .................. Bouton A        Z ............ Bouton B
  A .................. Bouton Y        S ............ Bouton X
  Q / E .............. L / R (epaules)
  T / Y .............. L2 / R2 (gachettes GBA)
  Entree ............. Start           Espace ....... Select
  I / J / K / M ...... C-stick N64 (haut/gauche/bas/droite)
  F1 ................. Menu RetroArch (Quitter, Sauver, etc.)

Pour re-mapper : dans RetroArch -> Parametres -> Entrees ->
Gestion des controles -> Toucher une touche avec la manette
clavier, ou modifier le bloc NINTENDO-KALI du fichier :
  ~/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg

------------------------------------------
 DOLPHIN (GameCube / Wii)
------------------------------------------
  Config -> Commandes -> "GameCube : Peripherique standard"
  -> Peripherique : "evdev / clavier", puis mapper :
     A=X, B=Z, Start=Entree, D-pad=Fleches, Z=A, gachette droite=R, etc.
  Utiliser la meme table que RetroArch pour rester coherent.

------------------------------------------
 MELONDS (Nintendo DS)
------------------------------------------
  Options -> Emulation Settings (Manette 1) : le champ
  capture chaque touche clavier cliquee ; reprendre la table
  ci-dessus (A bas = X, B bas = Z, etc.).
  Note : le stylet de la DS se joue a la souris (glisser = tracer).

Astuce : ces mappings fonctionnent aussi bien sur AZERTY que QWERTY
(les lettres sont capturees comme caracteres, pas comme positions).
EOF
