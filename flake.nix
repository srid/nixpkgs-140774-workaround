{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];
      flake.flakeModule = { self, config, lib, ... }: {
        flake.haskellFlakeProjectModules.fixNixpkgs140774 = { pkgs, ... }: {
          overrides =
            let
              disableSeparateBinOutput =
                pkgs.haskell.lib.compose.overrideCabal (_: { enableSeparateBinOutput = false; });
            in
            self: super: lib.optionalAttrs (pkgs.system == "aarch64-darwin") {
              ghcid = disableSeparateBinOutput super.ghcid;
              ormolu = disableSeparateBinOutput super.ormolu;
            };
        };
      };
    };
}
