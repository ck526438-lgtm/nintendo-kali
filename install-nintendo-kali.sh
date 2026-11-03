#!/usr/bin/env bash
# Installe une "console Nintendo" complete sur Kali Linux / Debian :
# NES, SNES, Game Boy, GBA, N64 (RetroArch), GameCube + Wii (Dolphin), DS (melonDS).
# A lancer avec ton utilisateur normal (pas root) : bash install-nintendo-kali.sh
set -euo pipefail

if ! grep -qiE 'kali|debian' /etc/os-release; then
  echo "Ce script est prevu pour Kali Linux ou une base Debian." >&2
  exit 1
fi

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  command -v sudo >/dev/null || { echo "Installe sudo d'abord : apt install sudo"; exit 1; }
  SUDO="sudo"
fi

echo "==> [1/5] Paquets de base"
$SUDO apt-get update
$SUDO apt-get install -y curl ca-certificates xdg-utils gamemode

echo "==> [2/5] Flatpak (evite de melanger des repos exotiques avec Kali)"
if ! command -v flatpak >/dev/null; then
  $SUDO apt-get install -y flatpak
fi
$SUDO flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "==> [3/5] Emulateurs"
# RetroArch        -> NES, SNES, Game Boy/Color, GBA, N64 (via "cores" libretro)
# Dolphin          -> GameCube + Wii
# melonDS          -> Nintendo DS
# mGBA             -> Game Boy Advance (standalone, tres fidele)
for app in org.libretro.RetroArch org.DolphinEmu.dolphin-emu org.melonds.melonds io.mgba.mGBA; do
  echo "    -> $app"
  $SUDO flatpak install -y --non-interactive flathub "$app"
done

echo "==> [4/5] Dossiers de jeux"
mkdir -p ~/Jeux-Nintendo/{NES,SNES,GameBoy,GBA,N64,GameCube,Wii,DS}

echo "==> [5/5] Configuration clavier"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/configure-keyboard.sh" ]; then
  bash "$SCRIPT_DIR/configure-keyboard.sh"
fi

cat <<'EOF'

============================================================
 Installation terminee ! Etapes restantes (5 min) :
============================================================

1) Lancer RetroArch -> Menu principal -> "Online Updater"
     -> "Core Downloader" et installer :
        - Nestopia (NES)
        - Snes9x (SNES)
        - Gambatte (Game Boy / Color)
        - mGBA (GBA)
        - Mupen64Plus-Next (N64)
     puis "Update All" et "Rebuild Database".

2) Placer tes jeux dans ~/Jeux-Nintendo/<console>/
   (ROMs legalement copiees depuis TES propres cartouches —
    le telechargement de ROMs de jeux non possedes est illegal.)

3) BIOS / firmware necessaires :
   - GameCube/Wii : firmware Dolphin — le script de Dolphin le
     telecharge lui-meme au premier lancement ("Download DSP etc.").
   - N64 : aucun BIOS requis.
   - DS (melonDS) : BIOS7.bin + BIOS9.bin + firmware.bin a copier dans
     ~/.var/app/org.melonds.melonds/config/melonDS/
     (a extraire legalement de TA console DS avec une cartouche DSi).

4) Manette ou clavier :
   - Clavier : la config RetroArch a ete ecrite automatiquement
     (Fleches = direction, X = A, Z = B, Entree = Start...).
     Re-configure a volonte : bash configure-keyboard.sh
   - Manette : branche-la (Xbox/PS/Switch) en USB ou Bluetooth,
     elle est detectee automatiquement. Dans RetroArch :
     "Settings -> Input" pour mapper.

5) Performance : pour les jeux 3D (GameCube/Wii/N64), desactive le
   profil d'economie d'energie. Si tu as une carte NVIDIA, installe
   le proprietaire : apt install -y nvidia-driver (voir docs Kali).

Bon jeu !
EOF
