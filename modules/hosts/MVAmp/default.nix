{ self, inputs, ... }: {
  flake.nixosConfigurations.MVAmp = inputs.nixpkgs.lib.nixosSystem{
    modules = [
      self.nixosModules.MVAmpConfiguration
    ];
  };
}
