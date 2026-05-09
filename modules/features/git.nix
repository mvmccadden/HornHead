{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      package = pkgs.gitFull;
      settings = {
        user = {
          name = "mvmccadden";
          email = "mccaddenmanoel@gmail.com";
        };
        init.defaultBranch = "main";
        credential.helper = "libsecret";
      };
    };
  };
}
