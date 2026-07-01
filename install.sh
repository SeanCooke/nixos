# Usage: ./install.sh
echo "          _                                        _____      "
echo "   ____  (_)  ______  _____      _________  ____  / __(_)_____"
echo "  / __ \/ / |/_/ __ \/ ___/_____/ ___/ __ \/ __ \/ /_/ / __  /"
echo " / / / / />  </ /_/ (__  )_____/ /__/ /_/ / / / / __/ / /_/ / " 
echo "/_/ /_/_/_/|_|\____/____/      \___/\____/_/ /_/_/ /_/\__, /  "
echo "                                                     /____/   "
cd ~/
nix-shell -p git
git clone https://github.com/SeanCooke/nixos-config
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/nixos
sudo rm -rf /etc/nixos
sudo rm -rf ~/.config/home-manager 
sudo ln -s ~/nixos-config/nixos /etc/nixos
sudo ln -s ~/nixos-config/home-manager ~/.config/home-manager
