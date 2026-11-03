#!/usr/bin/env bash
# Installe un pack retro Nintendo sur macOS via Homebrew :
# RetroArch (NES/SNES/GB/GBA/N64), Dolphin (GameCube/Wii), melonDS (DS), mGBA.
# + configuration clavier automatique pour RetroArch.
# Lancer : bash install-nintendo-macos.sh
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "Ce script est pour macOS." >&2
  exit 1
fi

echo "==> [1/4] Homebrew"
if ! command -v brew >/dev/null; then
  echo "Homebrew n'est pas installe. Installe-le d'abord :" >&2
  echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
  exit 1
fi

echo "==> [2/4] Emulateurs"
for cask in retroarch dolphin melonds mgba; do
  echo "    -> $cask"
  if ! brew install --cask "$cask"; then
    echo "    !! echec d'installation de $cask (verifie le nom avec: brew search $cask)" >&2
  fi
done

echo "==> [3/4] Dossiers de jeux"
mkdir -p ~/Jeux-Nintendo/{NES,SNES,GameBoy,GBA,N64,GameCube,Wii,DS}

echo "==> [4/4] Configuration clavier RetroArch"
CFG_DIR="$HOME/Library/Application Support/RetroArch"
mkdir -p "$CFG_DIR"
CFG="$CFG_DIR/retroarch.cfg"
touch "$CFG"
if grep -q "# BEGIN NINTENDO-KALI KEYBOARD" "$CFG"; then
  sed -i '' '/# BEGIN NINTENDO-KALI KEYBOARD/,/# END NINTENDO-KALI KEYBOARD/d' "$CFG"
fi
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
============================================================
 Installation terminee !
============================================================
 1) Lance RetroArch -> Online Updater -> Core Downloader :
    Nestopia (NES), Snes9x (SNES), Gambatte (GB/GBC), mGBA (GBA),
    Mupen64Plus-Next (N64), puis Update All + Rebuild Database.
 2) Jeux dans ~/Jeux-Nintendo/<console>/
    (ROMs copiees depuis TES propres cartouches).
 3) Clavier RetroArch deja configure : Fleches = direction,
    X = A, Z = B, A/S = Y/X, Q/E = L/R, Entree = Start,
    Espace = Select, F1 = menu. Manette branchee = auto.
 4) Gatekeeper : si macOS bloque un emulateur au premier
    lancement, fais clic droit -> Ouvrir, puis va dans
    Reglages Systeme -> Confidentialite pour l'autoriser.

Note GameCube/Wii : Dolphin sur Apple Silicon (M1/M2/M3) est
encore lent ; privilegie NES/SNES/GBA/N64/DS sur ces Mac.
EOF
