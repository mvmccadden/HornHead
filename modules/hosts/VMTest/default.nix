{ self, inputs, ... }: {
  flake.nixosConfigurations.VMTest = inputs.nixpkgs.lib.nixosSystem{
    modules = [
      self.nixosModules.VMTestConfiguration
    ];
  };
}
