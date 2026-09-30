{
  self,
  inputs,
  ...
}: {
  # Wire home-manager into the NixOS hosts and attach the per-app feature
  # modules (dendritic style). Each host just imports
  # `self.nixosModules.home-manager`.
  flake.nixosModules.home-manager = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";

      users.manoelv = {
        imports = [ self.homeModules.zed ];

        home = {
          username = "manoelv";
          homeDirectory = "/home/manoelv";
          stateVersion = "25.11";
        };
      };
    };
  };
}
