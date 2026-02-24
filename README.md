# nixos-config
Collection of configuration files for my personal NixOS laptop.

## Install
1. Clone this github repo into your home directory.
```bash
cd ~/
nix-shell -p git
git clone https://github.com/SeanCooke/nixos-config
```
2. Copy /etc/nixos/hardware-configuration.nix to ~/nixos-config/nixos.
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/nixos
```
3. Delete your /etc/nixos directory.
```bash
sudo rm -rf /etc/nixos
```
4. Delete your ~/.config/home-manager directory.
```bash
sudo rm -rf ~/.config/home-manager 
```
5. Create symlinks from /etc/nixos and ~/.config/home-manager to your ~/nixos-config directory.
```bash
sudo ln -s ~/nixos-config/nixos /etc/nixos
sudo ln -s ~/nixos-config/home-manager ~/.config/home-manager
``` 
