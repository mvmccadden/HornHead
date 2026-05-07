{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
	hotkey-overlay.skip-at-startup = true;

        spawn-at-startup = [
	  (lib.getExe self'.packages.myNoctalia)
	];

	xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

	input.keyboard.xkb.layout =  "us,ua";
	# May not need this now
	#input.keyboard.xkb.options = "caps:ctrl_modifier";
	input.keyboard.xkb.options = "ctrl:swapcaps";

	# Layout settings
	layout.gaps = 4;
	layout.focus-ring.width = 1;
        # Ensure focus ring is a true ring and not a background rectangle
        
	# Window rules
	window-rule.geometry-corner-radius = 15;
	window-rule.clip-to-geometry = true;

	prefer-no-csd = true;

	binds = {
	  # Open applications
	  "Mod+Return".spawn-sh = lib.getExe pkgs.foot;
	  "Mod+B".spawn-sh = lib.getExe inputs.zen-browser.packages."${pkgs.system}".beta;

	  # Desktop Functionality
	  "Mod+Q".close-window = null;

	  "Mod+M".maximize-column = null;
	  "Mod+F".fullscreen-window = null;
	  "Mod+Shift+F".toggle-window-floating = null;
	  "Mod+C".center-column = null;

	  "Mod+H".focus-column-left = null;
	  "Mod+L".focus-column-right = null;
	  "Mod+K".focus-window-up = null;
	  "Mod+J".focus-window-down = null;

	  "Mod+Shift+H".move-column-left = null;
	  "Mod+Shift+L".move-column-right = null;
	  "Mod+Shift+K".move-column-to-workspace-up = {};
	  "Mod+Shift+J".move-column-to-workspace-down= {};

	  "Mod+WheelScrollDown".focus-column-left = null;
	  "Mod+WheelScrollUp".focus-column-right = null;
	  "Mod+Shift+WheelScrollDown".focus-workspace-down = null;
	  "Mod+Shift+WheelScrollUp".focus-workspace-up = null;
	  "Mod+Shift+D".focus-workspace-down = null;
	  "Mod+Shift+U".focus-workspace-up = null;

	  # Extra
	  "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle"; 
	  "Mod+Escape".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call controlCenter toggle";
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
