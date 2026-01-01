# GNOME Desktop Environment Configuration
{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.fs.scanPaths ./.;

  # Portal configuration for GNOME
  # Prevents warning about xdg-desktop-portal 1.17+ requiring explicit config
  xdg.portal.config.common.default = lib.mkDefault "*";

  ## GNOME Desktop Environment ##
  services = {
    desktopManager.gnome = {
      enable = lib.mkDefault true;
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };

    gnome.core-apps.enable = lib.mkDefault true;

    # Disable xserver (pure Wayland)
    xserver.enable = lib.mkDefault false;

    udev.packages = lib.mkDefault (with pkgs; [ gnome-settings-daemon ]);
  };

  environment.systemPackages = lib.mkDefault (
    with pkgs;
    [
      gnome-tweaks
      papers # evince replacement
      eloquent # Spell checker
      resources
      cartridges
      nautilus-python
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.appindicator
      gnomeExtensions.auto-accent-colour
      gnomeExtensions.blur-my-shell
      gnomeExtensions.color-picker
      gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
      gnomeExtensions.dash-in-panel
      gnomeExtensions.flickernaut
      gnomeExtensions.just-perfection
      gnomeExtensions.pano
      gnomeExtensions.paperwm
      gnomeExtensions.quick-settings-audio-devices-hider
      gnomeExtensions.quick-settings-audio-devices-renamer
      gnomeExtensions.undecorate
      gnomeExtensions.vitals
    ]
  );

  ## Exclusions ##
  environment.gnome.excludePackages = lib.mkDefault (
    with pkgs;
    [
      atomix
      baobab
      evince
      geary
      gedit
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      gnome-user-docs
      gnomeExtensions.applications-menu
      gnomeExtensions.launch-new-instance
      gnomeExtensions.light-style
      gnomeExtensions.places-status-indicator
      gnomeExtensions.status-icons
      gnomeExtensions.system-monitor
      gnomeExtensions.window-list
      gnomeExtensions.windownavigator
      hitori
      iagno
      monitor
      simple-scan
      tali
      yelp
    ]
  );
}
