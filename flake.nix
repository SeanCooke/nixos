{
  description = "nixos-config — laptop system config with a VM test target";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      username = "scooke";
      fullName = "Sean Cooke";
      specialArgs = { inherit username fullName; };
      commonModules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username; };
          home-manager.users.${username} = import ./home-manager/home.nix;
        }
      ];
    in {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = commonModules ++ [
          ./nixos/hardware-configuration.nix
          { networking.hostName = "laptop"; }
        ];
      };

      nixosConfigurations.vmtest = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = commonModules ++ [
          ./nixos/vm.nix
          { networking.hostName = "vmtest"; }
        ];
      };
    };
}
