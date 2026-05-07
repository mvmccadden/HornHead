{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user = {
          name = "mvmccadden";
          email = "mccaddenmanoel@gmail.com";
        };
        init.defaultBranch = true;
      };
    };
  };
}
