{ lib, username, ... }:
{
  users.users.${username}.initialPassword = "nixos";
  users.users.root.initialPassword = "nixos";

  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  virtualisation.docker.enable = lib.mkForce false;

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 4;
    diskSize = 16384;
    graphics = true;
    resolution = { x = 1920; y = 1080; };
  };
}
