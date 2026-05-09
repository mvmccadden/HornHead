{ self, inputs, ... }: {
  flake.nixosConfigurations.Laptop = inputs.nixpkgs.lib.nixosSystem{
    modules = [
      self.nixosModules.LaptopConfiguration
    ];
  };
}
