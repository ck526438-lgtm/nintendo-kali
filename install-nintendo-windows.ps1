# Installe un pack retro Nintendo sur Windows 10/11 via winget :
# RetroArch (NES/SNES/GB/GBA/N64), Dolphin (GameCube/Wii), melonDS (DS), mGBA.
# + configuration clavier automatique pour RetroArch.
# Lancer dans PowerShell : powershell -ExecutionPolicy Bypass -File install-nintendo-windows.ps1
$ErrorActionPreference = "Stop"

Write-Host "==> [1/3] Emulateurs Nintendo (winget)"
$apps = [ordered]@{
    "Libretro.RetroArch"      = "NES, SNES, Game Boy, GBA, N64"
    "DolphinEmulator.Dolphin" = "GameCube + Wii"
    "melonDS.melonDS"         = "Nintendo DS"
    "JeffreyPfau.mGBA"        = "Game Boy Advance"
}

# Repli versions portables (telechargeables sans droits admin) si winget echoue
# (le paquet winget de Dolphin pointe vers un miroir 403 ; l'installateur mGBA exige l'UAC).
$portable = @{
    "DolphinEmulator.Dolphin" = @{ url = "https://dl.dolphin-emu.org/releases/2609a/dolphin-2609a-x64.7z"
                                   dest = "Dolphin" }
    "JeffreyPfau.mGBA"        = @{ url = "https://github.com/mgba-emu/mgba/releases/download/0.10.5/mGBA-0.10.5-win64.7z"
                                   dest = "mGBA" }
}
function Install-Portable($id) {
    $p = $portable[$id]
    $tmp = Join-Path $env:TEMP ("nk-" + (Split-Path -Leaf $p.url))
    Write-Host "    repli version portable : $($p.url)"
    Invoke-WebRequest -Uri $p.url -OutFile $tmp
    $dest = Join-Path $env:LOCALAPPDATA ("Programs\" + $p.dest)
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    tar -xf $tmp -C $dest
    Remove-Item $tmp -Force
    Write-Host "    -> installe dans $dest"
}

foreach ($id in $apps.Keys) {
    Write-Host "    -> $id ($($apps[$id]))"
    winget install -e --id $id --accept-package-agreements --accept-source-agreements
    if (($LASTEXITCODE -ne 0) -and $portable.Contains($id)) {
        Install-Portable $id
    }
}

Write-Host "==> [2/3] Dossiers de jeux"
$roms = Join-Path $HOME "Jeux-Nintendo"
foreach ($d in "NES","SNES","GameBoy","GBA","N64","GameCube","Wii","DS") {
    New-Item -ItemType Directory -Force -Path (Join-Path $roms $d) | Out-Null
}

Write-Host "==> [3/3] Configuration clavier RetroArch"
$cfgDir = Join-Path $env:APPDATA "RetroArch"
New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
$cfg = Join-Path $cfgDir "retroarch.cfg"
if (Test-Path $cfg) {
    $content = Get-Content $cfg -Raw
    $content = $content -replace '(?s)# BEGIN NINTENDO-KALI KEYBOARD.*?# END NINTENDO-KALI KEYBOARD\r?\n', ''
    Set-Content -Path $cfg -Value $content -NoNewline
} else {
    New-Item -ItemType File -Path $cfg | Out-Null
}
$block = @'
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
'@
Add-Content -Path $cfg -Value $block

Write-Host ""
Write-Host "============================================================"
Write-Host " Installation terminee !"
Write-Host "============================================================"
Write-Host " 1) Lance RetroArch -> Online Updater -> Core Downloader :"
Write-Host "    Nestopia (NES), Snes9x (SNES), Gambatte (GB/GBC), mGBA (GBA),"
Write-Host "    Mupen64Plus-Next (N64), puis Update All + Rebuild Database."
Write-Host " 2) Jeux dans $roms\<console>"
Write-Host "    (ROMs copiees depuis TES propres cartouches)."
Write-Host " 3) Clavier RetroArch deja configure : Fleches = direction,"
Write-Host "    X = A, Z = B, A/S = Y/X, Q/E = L/R, Entree = Start,"
Write-Host "    Espace = Select, F1 = menu. Manette branchee = auto."
Write-Host " 4) Dolphin : Config -> Commandes -> mapper le clavier"
Write-Host "    avec les memes touches. melonDS : menu Controller 1."
