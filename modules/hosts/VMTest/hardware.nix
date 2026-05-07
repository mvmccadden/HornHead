{ self, inputs, ... }: {
  
  flake.nixosModules.VMTestHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [

    ];

    boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/d167c07f-74d9-4b90-8428-7437fe92012b";
        fsType = "ext4";
      };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    virtualisation.virtualbox.guest.enable = true;
  };
}
