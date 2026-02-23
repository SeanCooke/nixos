# nixos
Collection of configuration files for my personal NixOS laptop.

## Install
1. Clone this github repo into your home directory.
```bash
cd ~/
nix-shell -p git
git clone https://github.com/SeanCooke/nixos
```
2. Copy /etc/nixos/hardware-configuration.nix to ~/nixos/nixos.
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos/nixos
```
3. Delete your /etc/nixos directory.
```bash
sudo rm -rf /etc/nixos
```
4. Delete your ~/.config/home-manager directory.
```bash
sudo rm -rf ~/.config/home-manager 
```
5. Create symlinks from /etc/nixos and ~/.config/home-manager to your ~/nixos directory.
```bash
sudo ln -s ~/nixos/nixos /etc/nixos
sudo ln -s ~/nixos/home-manager ~/.config/home-manager
``` 
