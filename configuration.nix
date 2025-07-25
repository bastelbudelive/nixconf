# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostName,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-bed158c3-2240-49e5-aa94-fc270bd4cc88".device =
    "/dev/disk/by-uuid/bed158c3-2240-49e5-aa94-fc270bd4cc88";
  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-443eaf18-a7c0-45cb-b4e9-ea4cfb011f3e".keyFile =
    "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-bed158c3-2240-49e5-aa94-fc270bd4cc88".keyFile =
    "/boot/crypto_keyfile.bin";
  networking.hostName = hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure console keymap
  console.keyMap = "de";

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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.schokopuddingg = {
    isNormalUser = true;
    description = "Schokopuddingg";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      discord
      telegram-desktop
      element-desktop
      btop
      bitwarden-desktop
      vscode
      rawtherapee
      darktable
      pix
      vlc
      alacritty
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.droid-sans-mono
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "de";
        variant = "";
      };

      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
          luadbi-mysql
          awesome-wm-widgets
        ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
