{
  outputs = { self }: {
    haskellFlakeProjectModules = {
      default = { pkgs, lib, ... }: {
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
      # For those scenarios your base package set is different, but you want
      # ormolu and ghcid from default package set.
      latestOrmoluAndGhcid = { pkgs, lib, ... }: {
        devShell.tools = _:
          let
            disableSeparateBinOutput =
              pkgs.haskell.lib.compose.overrideCabal (_: { enableSeparateBinOutput = false; });
          in
          with pkgs.haskellPackages; {
            ormolu = disableSeparateBinOutput ormolu;
            ghcid = disableSeparateBinOutput ghcid;
          };
      };
    };
  };
}
