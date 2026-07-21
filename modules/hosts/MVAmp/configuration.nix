{ self, inputs, ... }: {
 
  flake.nixosModules.MVAmpConfiguration = { pkgs, libs, config, ... }: {

    # Import modules
    imports = [
      self.nixosModules.MVAmpHardware
      self.nixosModules.niri
      self.nixosModules.foot
      self.nixosModules.neovim
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "nixos";

    networking.networkmanager= {
      enable = true;
      wifi.backend = "iwd";
      settings = {
        connection = {
          "wifi.powersave" = 2;
        };
      };
    };

    networking.wireless.iwd = {
      enable = true;
      settings = {
        General = {
          DisablePeriodicScan = true;
          AddressRandomization = "none";
        };
        Network = {
          NameResolutionService = "systemd-resolved";
        };
      };
    };

    time.timeZone = "America/Los_Angeles";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8"; 
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable GNOME 
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Setup niri as default enviornment
    services.displayManager.defaultSession = "niri";

    # Setup graphics settings
    hardware.graphics = {
      enable = true;
    };

    # Tell NixOS to use NVIDIA driver
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;

      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Attempt to help Nvidia handle console properly
    boot.loader.systemd-boot.consoleMode = "1";
    boot.kernelParams = [ 
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1" 
      "usbcore.autosuspend=-1"
    ];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.manoelv = {
      isNormalUser = true;
      description = "Manoel McCadden";
      extraGroups = [ "networkmanager" "wheel" ];
      #packages = with pkgs; [
      #  thunderbird
      #];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    environment.sessionVariables = {
      # removed to avoid issue with steam
      #GBM_BACKEND = "nvidia-drm";
      NIXOS_OZONE_WL = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # Additional flag to help compilers find CUDA drivers 
      EXTRA_LDFLAGS = "-L/run/opengl-driver/lib";
    };

    environment.systemPackages = with pkgs; [
      # Development Applications
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
      libsecret
      foot
      neovim
      zed-editor
      # Development Languages
      gcc
      gnumake
      cmake
      go
      python3
      nodejs
      rustup
      # CUDA # Development 
      cudaPackages.cudatoolkit
      cudaPackages.cuda_nvcc
      # Nix Applications 
      direnv
      nix-direnv
      # Embedded
      gcc-arm-embedded
      # System applications
      wl-clipboard
      wl-clip-persist
      # User Applications
      obsidian
      vesktop
      yazi
      thunar
      inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    # Enable/Disable wifi/ethernet for hotswaping
    environment.shellAliases = {
      wired-enable = "nmcli connection down 'FBI Van 0362' && nmcli connection up 'Wired connection 1'";
      wireless-enable = "nmcli connection down 'Wired connection 1' && nmcli connection up 'FBI Van 0362'";
    };

    # Setup font
    fonts.packages = with pkgs; [ 
      nerd-fonts.jetbrains-mono
    ];
    fonts.fontconfig.enable = true;

    # Setups zen to be default browser for clicking on links
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "*";
    };

    # Setup steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extest.enable = true;

      package = pkgs.steam.override {
        extraEnv = {
          XDG_SESSION_TYPE = "x11";
          QT_QPA_PLATFORM = "xcb";
          GDK_BACKEND = "x11";
          SDL_JOYSTICK_HIDAPI = "0";
          SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS = "0";
        };
      };
    };

    programs.gamescope.enable = true;

    system.stateVersion = "26.05";

    # Automatic updating
    system.autoUpgrade.enable = true;
    system.autoUpgrade.dates = "weekly";

    # Automatic cleaning
    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 10d";
    nix.gc.persistent = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    nix.settings.auto-optimise-store = true;
  };
}
