{
    description = "NixOS config";

    inputs = {
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:


    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.nvidia.acceptLicense = true;
            overlays = [
            (final: prev: {
                thorium = (import ./external/thorium.nix {
                    pkgs = prev; system = system;
                }).thorium;
            })
            ];
        };

        pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
        };
    
    in {
        nixosConfigurations = {
            olli = nixpkgs.lib.nixosSystem {
                inherit system pkgs;
                specialArgs = {
                    inherit pkgs-unstable;
                };
                modules = [
                    ./machines/shared/configuration.nix
                    ./machines/ollenovo/configuration.nix
                    # ./machines/ollenovo/gdm.nix
                    # ./machines/ollenovo/greetd.nix

                    inputs.home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
                        home-manager.users.localadmin = import ./home.nix;
                    }
                ];
            };
	    tyo = nixpkgs.lib.nixosSystem {
                inherit system pkgs;
                specialArgs = {
                    inherit pkgs-unstable;
                };
                modules = [
                    ./machines/shared/configuration.nix
                    ./machines/tyolappari/configuration.nix

                    inputs.home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
                        home-manager.users.localadmin = import ./home.nix;
                    }
                ];
            };
        };
    };
}
