{ self, inputs, ... }: {

  flake.nixosModules.LaptopConfiguration = { pkgs, libs, ... }: {

    # Import modules
    imports = [
      self.nixosModules.LaptopHardware
      self.nixosModules.niri
      self.nixosModules.foot
      self.nixosModules.neovim
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";

    networking.networkmanager.enable = true;

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

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = false;
    services.desktopManager.gnome.enable = false;

    # Keyring service 
    services.gnome.gnome-keyring.enable = true;

    # Setup niri as default enviornment
    services.displayManager.defaultSession = "niri";
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
      packages = with pkgs; [
      #  thunderbird
      ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      # Development Applications
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
      libsecret
      foot
      neovim
      zed-editor
      godot_4
      scons # Python construction
      # Development Languages
      gcc
      gnumake
      cmake
      go
      python3
      python-launcher
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
      unzip
      # User Applications
      obsidian
      discord 
      yazi
      thunar
      proton-vpn
      inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    # Setup font
    fonts.packages = with pkgs; [ 
      nerd-fonts.jetbrains-mono
    ];
    fonts.fontconfig.enable = true;

    # Setup LaptopHardware
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Setups zen to be default browser for clicking on links
    #xdg.portal.enable = true;

    system.stateVersion = "25.11";

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
