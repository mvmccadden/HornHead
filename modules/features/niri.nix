{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    services.upower.enable = true;

    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', system, ... }: let
    unfreePkgs = import pkgs.path {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  in {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      pkgs = unfreePkgs;
      # Make sure unfree package calls work
      settings = {
        hotkey-overlay.skip-at-startup = true;

        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        # Input
        input = {
          mouse = {
            # Using traditional scroll
            #natural-scroll = { };
          };

          touchpad = {
            natural-scroll = { };
          };

          keyboard = {
            xkb.layout = "us,ua";
            xkb.options = "ctrl:swapcaps";
            #xkb.options = "caps:ctrl_modifer";
          };
        };

        outputs = {
          "DP-5" = {
            transform = "normal";
            position = _: { props = { x = -1920; y = 0; }; };
          };

          "DP-4" = {
            mode = "1920x1080@144";
            transform = "normal";
            position = _: { props = { x = 0; y = 0; }; };
          };

          "Sceptre Tech Inc E205W-1600 0x062233CD" = {
            transform = "90";
            position = _: { props = { x = 1920; y = 0; }; };
          };
        };
        
        # Layout settings
        layout.gaps = 6;
        layout.focus-ring.width = 2;
        layout.struts.top = 6;
        layout.struts.bottom = 6;
        # Ensure focus ring is a true ring and not a background rectangle
              
        # Window rules
        window-rule.geometry-corner-radius = 15;
        window-rule.clip-to-geometry = true;

        prefer-no-csd = true;

        binds = {
          # Open applications
          "Mod+Return".spawn-sh = lib.getExe pkgs.foot;
          "Mod+E".spawn-sh = lib.getExe unfreePkgs.zed-editor;
          "Mod+O".spawn-sh = lib.getExe unfreePkgs.obsidian;
          "Mod+D".spawn-sh = lib.getExe unfreePkgs.discord;
          "Mod+B".spawn-sh = lib.getExe inputs.zen-browser.packages."${pkgs.system}".beta;

          # Desktop Functionality
          "Mod+Q".close-window = _: {};

          "Mod+M".maximize-column = _: {};
          "Mod+F".fullscreen-window = _: {};
          "Mod+Shift+F".toggle-window-floating = _: {};
          "Mod+C".center-column = _: {};

          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+J".focus-window-down = _: {};

          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+L".move-column-right = _: {};
          "Mod+Ctrl+H".move-window-to-monitor-left = _: {};
          "Mod+Ctrl+L".move-window-to-monitor-right = _: {};
          "Mod+Shift+K".move-column-to-workspace-up = {};
          "Mod+Shift+J".move-column-to-workspace-down= {};

          "Mod+WheelScrollDown".focus-column-left = _: {};
          "Mod+WheelScrollUp".focus-column-right = _: {};
          "Mod+Shift+WheelScrollDown".focus-workspace-down = _: {};
          "Mod+Shift+WheelScrollUp".focus-workspace-up = _: {};
          "Mod+Shift+D".focus-workspace-down = _: {};
          "Mod+Shift+U".focus-workspace-up = _: {};

          # Extra
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle"; 
          "Mod+Backspace".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call controlCenter toggle";
          "Mod+Escape".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call sessionMenu toggle";
          "Mod+S".spawn-sh = lib.getExe (pkgs.writeShellApplication {
            name = "screenshot";
            text = ''
              ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
            | ${pkgs.wl-clipboard}/bin/wl-copy
          '';
          });
        };
      };
    };
  };
}
