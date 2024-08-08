{
  description = "NixOS config";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-matlab.url = "gitlab:doronbehar/nix-matlab";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-flake.url = "github:saippua/nvim-flake";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nix-matlab, home-manager, nvim-flake, ... }:

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
        overlays = [
          nvim-flake.overlays.default
        ];
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
                  font_size = 9;
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
          nix = {
            package = pkgs.nix;
            settings.experimental-features = [ "nix-command" "flakes" ];
          };
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
	wsl = nixpkgs.lib.nixosSystem {
		inherit system pkgs;
		specialArgs = {
		inherit unstable;
		};
		modules = [
			./machines/koti_wsl/configuration.nix
			inputs.home-manager.nixosModules.home-manager
			{
				home-manager.extraSpecialArgs = {
					inherit system pkgs unstable;
					opts = {
						withGUI = false;
						withVPN = false;
						withMatlab = false;
						isOfficial = false;
					};
				};
			home-manager.users.localadmin = import ./home.nix;
			}
		];
	};
      };
    };
}
