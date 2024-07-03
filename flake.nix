{
  description = "NixOS config";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nix-matlab.url = "gitlab:doronbehar/nix-matlab";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nix-matlab, home-manager, ... }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          nvidia.acceptLicense = true;
        };
        overlays = [
          (final: prev: {
            thorium = (import ./external/thorium.nix {
              pkgs = prev;
              system = system;
            }).thorium;
          })
          nix-matlab.overlay
        ];
      };

      unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          nvidia.acceptLicense = true;
        };
      };

    in
    {
      nixosConfigurations = {
        olli = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./machines/ollenovo/configuration.nix

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit system pkgs unstable;
                opts = {
                  withGUI = true;
                  withVPN = false;
                  withMatlab = false;
                  isOfficial = false;
                };
              };
              home-manager.users.localadmin = import ./home.nix;
            }
          ];
        };
        tyo = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit unstable;
          };
          modules = [
            ./machines/tyolappari/configuration.nix

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit system pkgs unstable;
                opts = {
                  withGUI = true;
                  withVPN = true;
                  withMatlab = true;
                  isOfficial = true;
                };
              };
              home-manager.users.localadmin = import ./home.nix;
            }
          ];
        };
        teho = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./home.nix {
              inherit system pkgs unstable;
              opts = {
                withGUI = true;
                withVPN = false;
                withMatlab = false;
                isOfficial = true;
              };
            })
          ];
        };
      };
    };
}
