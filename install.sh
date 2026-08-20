#!/usr/bin/env bash
# Usage: ./install.sh
# Installs nixos-config on the current machine.
set -euo pipefail

cat <<'EOF'
          _                                        _____
   ____  (_)  ______  _____      _________  ____  / __(_)___ _
  / __ \/ / |/_/ __ \/ ___/_____/ ___/ __ \/ __ \/ /_/ / __ `/
 / / / / />  </ /_/ (__  )_____/ /__/ /_/ / / / / __/ / /_/ /
/_/ /_/_/_/|_|\____/____/      \___/\____/_/ /_/_/ /_/\__, /
                                                     /____/
EOF

# Replace the tracked hardware scan with this machine's own.
cp /etc/nixos/hardware-configuration.nix "$HOME/nixos-config/nixos/"

# Enable flakes and rebuild.
sudo NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch --flake "$HOME/nixos-config#laptop"
