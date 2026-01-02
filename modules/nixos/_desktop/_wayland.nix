# Shared Wayland Compositor Configuration
#
# Common infrastructure for Wayland compositors (Hyprland, Niri).
# Includes: audio, networking, DDC, polkit, keyring, fonts, etc.
#
{
  host,
  lib,
  pkgs,
  ...
}:

{
  # Common Packages
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    kooha # Screen recorder GUI
    libnotify # Desktop notifications
    wev # Event viewer for debugging keybindings
    wf-recorder # Screen recording
    wl-clipboard-rs # Rust clipboard utilities

    # Utility
    gnome-disk-utility
    qdirstat

    # Media control
    playerctl
    pavucontrol
    wireplumber

    # Applications
    clapper # Media player
    eloquent # Spell checker
    loupe # Image viewer
  ];

  # Audio (PipeWire)
  services.pipewire = {
    enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    wireplumber.enable = lib.mkDefault true;
  };

  # Networking
  programs.nm-applet = {
    enable = lib.mkDefault true;
    indicator = lib.mkDefault true; # AppIndicator mode (better for Wayland)
  };

  # DDC/CI Brightness Control (external monitors)
  hardware.i2c.enable = lib.mkDefault true;

  services.udev.extraRules = lib.mkDefault ''
    # Allow users in video group to access i2c devices
    KERNEL=="i2c-[0-9]*", GROUP="video", MODE="0660"
  '';

  users.users.${host.user.name}.extraGroups = lib.mkDefault [ "video" ];

  # Security & Authentication
  security.polkit.enable = lib.mkDefault true;
  services.gnome.gnome-keyring.enable = lib.mkDefault true;

  # Environment Variables
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = lib.mkDefault "1"; # Java apps
    ELECTRON_OZONE_PLATFORM_HINT = lib.mkDefault "wayland"; # Electron apps
    MOZ_ENABLE_WAYLAND = lib.mkDefault "1"; # Firefox
    NIXOS_OZONE_WL = lib.mkDefault "1"; # Electron apps on Wayland
    QT_QPA_PLATFORM = lib.mkDefault "wayland"; # Qt apps
    SDL_VIDEODRIVER = lib.mkDefault "wayland"; # SDL apps
    XDG_SESSION_TYPE = lib.mkDefault "wayland";
  };

  # Location & Power
  services.geoclue2.enable = lib.mkDefault true;

  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkDefault "suspend";
    HandleLidSwitchExternalPower = lib.mkDefault "lock";
  };

  # Font Rendering
  fonts.fontconfig = {
    enable = lib.mkDefault true;
    antialias = lib.mkDefault true;
    hinting.enable = lib.mkDefault true;
    subpixel.rgba = lib.mkDefault "rgb";
  };
}
