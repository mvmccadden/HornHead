{ inputs, ... }: {
  config = {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    # Match the hosts' `nixpkgs.config.allowUnfree = true` so wrapper-modules
    # can evaluate packages (e.g. `replace`) that nixpkgs marks as unfree.
    perSystem = { system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  };
}
