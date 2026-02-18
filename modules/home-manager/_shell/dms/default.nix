# DankMaterialShell - Unified configuration for niri and hyprland
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
  plugins = import ./_plugins.nix { inherit arrozInputs lib pkgs; };
in
{
  imports = lib.flatten [
    arrozInputs.dankMaterialShell.homeModules.dank-material-shell
    (lib.optional isNiri arrozInputs.dankMaterialShell.homeModules.niri)
    (lib.fs.scanPaths ./.)
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
  };

  programs.dank-material-shell = {
    enable = lib.mkDefault true;
    quickshell.package = arrozInputs.quickshell.packages.${system}.default;

    # Systemd integration for DMS
    systemd = {
      enable = lib.mkDefault true;
      restartIfChanged = lib.mkDefault true;
    };

    # Core features
    enableSystemMonitoring = lib.mkDefault true;
    enableVPN = lib.mkDefault true;
    enableDynamicTheming = lib.mkDefault true;
    enableAudioWavelength = lib.mkDefault true;
    enableCalendarEvents = lib.mkDefault true;
    enableClipboardPaste = lib.mkDefault true;

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
