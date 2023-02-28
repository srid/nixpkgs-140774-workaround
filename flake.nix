{
  outputs = { self }:
    let
      disableSeparateBinOutput = pkgs:
        pkgs.haskell.lib.compose.overrideCabal (_: { enableSeparateBinOutput = false; });
    in
    {
      haskellFlakeProjectModules = {
        default = { pkgs, lib, ... }: {
          overrides =
            self: super: lib.optionalAttrs (pkgs.system == "aarch64-darwin") {
              ghcid = disableSeparateBinOutput pkgs super.ghcid;
              ormolu = disableSeparateBinOutput pkgs super.ormolu;
            };
        };
      };
      # For those scenarios your base package set is different, but you want
      # ormolu and ghcid from default package set.
      packages = { pkgs, ... }:
        with pkgs.haskellPackages; {
          ormolu = disableSeparateBinOutput pkgs ormolu;
          ghcid = disableSeparateBinOutput pkgs ghcid;
        };
    };
}
  