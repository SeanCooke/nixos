# nixos-config
Collection of configuration files for my personal NixOS laptop, managed as a [Nix flake](https://nixos.wiki/wiki/flakes).

Package versions are pinned in `flake.lock`, so rebuilding this configuration produces the same system on every machine until the lock file is deliberately updated.

## Layout
- `flake.nix` — Entrypoint. Defines the `laptop` system and wires in [Home Manager](https://github.com/nix-community/home-manager) as a NixOS module.
- `flake.lock` — Pinned revisions of `nixpkgs` and `home-manager`.
- `nixos/configuration.nix` — System configuration.
- `nixos/hardware-configuration.nix` — Hardware scan. Machine specific; replace it with your own.
- `home-manager/home.nix` — User configuration.

## Install
1. Clone this github repo into your home directory.
```bash
cd ~/
nix-shell -p git
git clone https://github.com/SeanCooke/nixos-config
```

2. Change into the repo. Every command below is run from here.
```bash
cd ~/nixos-config
```

3. Replace nixos/hardware-configuration.nix with your /etc/nixos/hardware-configuration.nix.
```bash
cp /etc/nixos/hardware-configuration.nix nixos/
```

4. Build and activate the configuration. Flakes are an experimental feature and are not enabled on a stock NixOS install, so turn them on for this first rebuild.
```bash
sudo NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch --flake .#laptop
```

Once this configuration is active, flakes are enabled system wide by `nixos/configuration.nix` and later rebuilds no longer need `NIX_CONFIG`.

Home Manager is applied by that same command. There is no separate `home-manager switch` step, and neither `/etc/nixos` nor `~/.config/home-manager` needs to be symlinked to this repo.

## Rebuild
After editing any file in this repo.
```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#laptop
```

A flake only sees files that git tracks. Editing a file already in the repo is enough, but a file you add must be `git add`ed before `nixos-rebuild` will see it.

## Update
Bump the pinned `nixpkgs` and `home-manager` revisions, then rebuild.
```bash
cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#laptop
```

Commit the resulting `flake.lock` to keep every machine on the same package versions.

## NordVPN
The `networkmanager-openvpn` plugin enabled in `nixos/configuration.nix` lets you import NordVPN OpenVPN profiles and toggle them from the GNOME system menu. GNOME has no traditional tray, so the VPN switch lives in the top-right Quick Settings menu alongside Wi-Fi and volume.

1. After the first rebuild that adds the plugin, restart NetworkManager so it loads the new VPN service. Otherwise activating the VPN fails with `The VPN service 'org.freedesktop.NetworkManager.openvpn' was not installed`. A reboot works too.
```bash
sudo systemctl restart NetworkManager
```

2. From the [NordVPN dashboard](https://my.nordaccount.com/), open **NordVPN** → **Manual setup** and copy your **service credentials** (a username and password separate from your account login).

3. Download an OpenVPN config file (`.ovpn`) for a server from that same page or the [server recommender](https://nordvpn.com/servers/tools/).

4. Import it: **Settings** → **Network** → **VPN** → **+** → **Import from file**, select the `.ovpn`, enter the service username and password, then **Add**.

5. Toggle the VPN on or off from the top-right system menu. Confirm it worked at [nordvpn.com/what-is-my-ip](https://nordvpn.com/what-is-my-ip/), which should show the server's location instead of your home IP. Repeat steps 3–4 with another `.ovpn` to add a different server.
