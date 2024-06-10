{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    # flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... } @ inputs: 

  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          python3
          (python3.withPackages (p: with p; [
            dbus-python
          ]))
        ];
        shellHook = ''
          PYTHONPATH=${pkgs.python3}/${pkgs.python3.sitePackages} zsh -l
        '';
      };
    });
}
