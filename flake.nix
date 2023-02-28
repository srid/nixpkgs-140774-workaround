{
  outputs = { self }:
    let
      disableSeparateBinOutput = pkgs:
        pkgs.haskell.lib.compose.overrideCabal (_: { enableSeparateBinOutput = false; });
      patch = pkgs: p:
        if pkgs.system == "aarch64-darwin" then disableSeparateBinOutput pkgs p else p;
    in
    {
      inherit patch;
      haskellFlakeProjectModules = {
        default = { pkgs, lib, ... }: {
          overrides =
            self: super: {
              ghcid = patch pkgs super.ghcid;
              ormolu = patch pkgs super.ormolu;
            };
        };
      };
      # For those scenarios your base package set is different, but you want
      # ormolu and ghcid from default package set.
      packages = { pkgs, ... }:
        with pkgs.haskellPackages; {
          ormolu = patch pkgs ormolu;
          ghcid = patch pkgs ghcid;
        };
    };
}
  