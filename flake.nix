{
  description = "Qylock Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { pkgs, self', ... }: {
        packages.default = ( pkgs.callPackage ./qylock-sddm.nix {  } );
        packages.test = self'.packages.default.override {
          lockscreenTheme = "star-rail";
          sddmFont = ./zhcn.ttf;
          lockscreenFont = ./zhcn.ttf;
        };
      };
    };
}
