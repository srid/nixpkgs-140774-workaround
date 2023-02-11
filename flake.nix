{
  outputs = { self }: {
    haskellFlakeProjectModules.default = { pkgs, lib, ... }: {
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
}
