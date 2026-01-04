# DankMaterialShell - Unified configuration for niri and hyprland
# Automatically applies compositor-specific settings based on host.desktop
{
  arrozInputs,
  host,
  lib,
  pkgs,
  ...
}:

let
  desktop = host.desktop or { };
  system = pkgs.stdenv.hostPlatform.system;
  isNiri = desktop.niri.enable or false;
  plugins = import ./_plugins.nix { inherit lib pkgs; };
in
{
  imports = lib.flatten [
    arrozInputs.dankMaterialShell.homeModules.dank-material-shell
    (lib.optional isNiri arrozInputs.dankMaterialShell.homeModules.niri)
    (lib.fs.scanPaths ./.)
  ];

  # Set Qt platform theme for consistent theming
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
  };

  # DankMaterialShell base configuration
  programs.dank-material-shell = {
    enable = lib.mkDefault true;
    quickshell.package = arrozInputs.quickshell.packages.${system}.default;

    # Systemd service for DMS
    systemd.enable = lib.mkDefault true;

    # Default settings/session (empty for now, can be customized per-host)
    settings = lib.mkDefault { };
    session = lib.mkDefault { };

    # Core features
    enableSystemMonitoring = lib.mkDefault true; # System monitoring widgets (dgop)
    enableVPN = lib.mkDefault true; # VPN management widget
    enableDynamicTheming = lib.mkDefault true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = lib.mkDefault true; # Audio visualizer (cava)
    enableCalendarEvents = lib.mkDefault true; # Calendar integration (khal)

    # Plugins
    plugins = {
      dankActions = {
        enable = lib.mkDefault true;
        src = plugins.dankActionsPlugin;
      };
      easyEffects = {
        enable = lib.mkDefault true;
        src = plugins.easyEffectsPlugin;
      };
      displaySettings = {
        enable = lib.mkDefault true;
        src = plugins.displaySettingsPlugin;
      };
      nixMonitor = {
        enable = lib.mkDefault true;
        src = plugins.nixMonitorPlugin;
      };
    };

  }
  // lib.optionalAttrs isNiri {
    # Disable DMS includes override; we have more specific options
    niri.includes.override = false;
  };
}
