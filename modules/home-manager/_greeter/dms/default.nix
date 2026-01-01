# DankMaterialShell - Unified configuration for niri and hyprland
# Automatically applies compositor-specific settings based on host.desktop
{
  host,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  desktop = host.desktop or { };

  # Compositor detection
  isNiri = desktop.niri.enable or false;
  isHyprland = desktop.hyprland.enable or false;

  # DMS shell package for Hyprland exec-once
  dms-shell = inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;

  # Import plugin definitions
  plugins = import ./_plugins.nix { inherit lib pkgs; };
in
{
  # Import DankMaterialShell modules - base + compositor-specific + vicinae
  imports = lib.flatten [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    (lib.optional isNiri inputs.dankMaterialShell.homeModules.dankMaterialShell.niri)
    ./vicinae.nix
  ];

  # DankMaterialShell base configuration
  programs.dank-material-shell = {
    enable = lib.mkDefault true;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
    # Niri-specific: Auto-start DMS with niri
    niri.enableSpawn = true;
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Hyprland DMS Startup
  # ══════════════════════════════════════════════════════════════════════════
  # Simple exec-once, same approach as Niri's enableSpawn
  wayland.windowManager.hyprland.settings.exec-once = lib.mkIf isHyprland [
    "${dms-shell}/bin/dms run"
  ];
}
