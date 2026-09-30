{
  self,
  inputs,
  ...
}: {
  # Home-manager module for Zed. Exposed as `self.homeModules.zed` and pulled
  # in by `self.nixosModules.home-manager`.
  #
  # The canonical config lives as plain, strict-JSON files next to this module
  # (`./zed/settings.json`, `./zed/keymap.json`) so the exact same two files can
  # be copied to `%APPDATA%\Zed\` on Windows.
  flake.homeModules.zed = { pkgs, lib, ... }: {
    programs.zed-editor = {
      enable = true;

      # Zed itself is provided system-wide via `environment.systemPackages`.
      package = null;

      userSettings = builtins.fromJSON (builtins.readFile ./zed/settings.json);
      userKeymaps = builtins.fromJSON (builtins.readFile ./zed/keymap.json);

      # Let Zed keep editing settings/keymap at runtime; Nix re-merges the
      # managed keys on every rebuild.
      mutableUserSettings = true;
      mutableUserKeymaps = true;
    };

    # The nixpkgs package only ships `zeditor`; expose the conventional `zed`
    # command so `zed .` (open a folder) works.
    home.packages = [
      (pkgs.runCommand "zed-cli" { } ''
        mkdir -p $out/bin
        ln -s ${lib.getExe pkgs.zed-editor} $out/bin/zed
      '')
    ];
  };
}
