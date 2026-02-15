# nixos
Collection of configuration files for my personal NixOS laptop.

## Install
1. Clone this github repo into your home directory.
```bash
cd ~/
git clone https://github.com/SeanCooke/nixos
```
2. Copy /etc/nixos/hardware-configuration.nix to ~/nixos.
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos
```
3. Delete your /etc/nixos directory.
```bash
sudo rm -rf /etc/nixos
```
4. Create a symlink from /etc/nixos to your ~/nixos directory.
```
sudo ln -s /home/scooke/nixos/ /etc/nixos
``` 
