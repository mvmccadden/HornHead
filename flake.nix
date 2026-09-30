{
  inputs = {
    # Nix setup inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # home-manager for declarative user application config (e.g. Zed)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvf neovim in nixos
    nvf.url = "github:notashelf/nvf";

    # User application inputs
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake 
    {inherit inputs;} 
    (inputs.import-tree ./modules);
}
