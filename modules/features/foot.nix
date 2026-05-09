{ self, inputs, ... }: {
  flake.nixosModules.foot = { pkgs, lib, ... }: {
    environment.systemPackages = [ pkgs.foot ];

    environment.etc."xdg/foot/foot.ini".text = ''
      font=JetBrainsMono Nerd Font:size=11

      [main]
      include=~/.config/foot/themes/noctalia

      [colors-dark]
      alpha=0.95
      alpha-mode=all

      [mouse]
      hide-when-typing=yes
    '';
  };
}
