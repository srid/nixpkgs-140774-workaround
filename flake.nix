{
  outputs = { self }:
    let
      patch = { pkgs, ... }:
        if pkgs.system == "aarch64-darwin" then { enableSeparateBinOutput = false; } else { };
      patchDrv = pkgs: pkgs.haskell.lib.compose.overrideCabal (old: patch { inherit pkgs; });
    in
    {
      inherit patch patchDrv;
      haskellFlakeProjectModules = {
        default = { pkgs, lib, ... }: {
          packageSettings = {
            ghcid.overrides = patch { inherit pkgs; };
            ormolu.overrides = patch { inherit pkgs; };
          };
        };
      };
      # For those scenarios your base package set is different, but you want
      # ormolu and ghcid from default package set.
      packages = { pkgs, ... }:
        with pkgs.haskellPackages; {
          ormolu = patchDrv pkgs ormolu;
          ghcid = patchDrv pkgs ghcid;
        };
    };
}
  