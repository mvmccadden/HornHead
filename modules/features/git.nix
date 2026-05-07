{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.git = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.git;
      env = rec {
        GIT_AUTHOR_NAME = "mvmccadden";
        GIT_AUTHOR_EMAIL = "mccaddenmanoel@mgmail.com";
        GIT_COMITTER_NAME = GIT_AUTHOR_NAME;
        GIT_COMITTER_EMAIL = GIT_AUTHOR_EMAIL;
      };
    };
  };
}
