{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];

  # nix
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # networking / locale
  networking.hostName = "eggoil";
  networking.networkmanager.enable = true;
  # faxproj lab: let the WireGuard peer (10.73.0.2, the only AllowedIPs on
  # wg0) start SIP/T.38 calls to Asterisk. Only the fax ports, only on wg0.
  networking.firewall.interfaces.wg0 = {
    allowedUDPPorts = [ 5060 ]; # SIP (pjsip transport-udp)
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4999;
      } # UDPTL / T.38 (udptl.conf)
      {
        from = 10000;
        to = 20000;
      } # RTP, pre-T.38 audio (rtp.conf)
    ];
  };
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # hardware
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;
  zramSwap.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
    };
  };

  # audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # desktop
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  security.pam.services.hyprlock = { };

  services.displayManager.defaultSession = "hyprland";
  services.displayManager.sessionPackages = [
    (
      (pkgs.writeTextFile {
        name = "driftwm-dev-session";
        destination = "/share/wayland-sessions/driftwm-dev.desktop";
        text = ''
          [Desktop Entry]
          Name=driftwm (dev)
          Comment=Local dev build of driftwm
          Exec=/home/eggoil/.local/bin/driftwm-dev
          Type=Application
        '';
      }).overrideAttrs
      (old: {
        passthru = (old.passthru or { }) // {
          providedSessions = [ "driftwm-dev" ];
        };
      })
    )
  ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    settings.Theme = {
      CursorTheme = "Bibata-Modern-Ice";
      CursorSize = 24;
    };
  };

  catppuccin = {
    flavor = "mocha";
    accent = "mauve";
    sddm = {
      enable = true;
      font = "JetBrainsMono Nerd Font";
    };
    tty.enable = true;
    plymouth.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
  ];

  # users
  users.users.eggoil = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
  };

  programs.firefox.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    bibata-cursors
    kew
  ];

  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from.
  # Do NOT change it unless you have read the release notes and migrated your data.
  system.stateVersion = "26.05";
}
