# DankMaterialShell - Niri shell configuration
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

  home.packages = with pkgs; [
    amdgpu_top
    arrozInputs.anker-c200.packages.${system}.anker-c200
    cliphist
    curl
    jq
    wl-clipboard
  ];

  programs.dank-material-shell = {
    enable = lib.mkDefault true;
    quickshell.package = arrozInputs.quickshell.packages.${system}.default;

    # DMS runtime owns mutable JSON state/settings, including plugin_settings.json.
    managePluginSettings = lib.mkDefault false;

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
      quickTote = {
        enable = lib.mkDefault true;
        src = plugins.quickTotePlugin;
      };
      clipboardPlus = {
        enable = lib.mkDefault true;
        src = plugins.clipboardPlusPlugin;
      };
      githubHeatmapRevive = {
        enable = lib.mkDefault true;
        src = plugins.githubHeatmapPlugin;
      };
      amdGpuMonitorRevive = {
        enable = lib.mkDefault true;
        src = plugins.amdGpuMonitorPlugin;
      };
      catWidget = {
        enable = lib.mkDefault true;
        src = plugins.catWidgetPlugin;
      };
      aiUsage = {
        enable = lib.mkDefault true;
        src = plugins.aiUsagePlugin;
      };
      ankerC200 = {
        enable = lib.mkDefault true;
        src = plugins.ankerC200Plugin;
      };
    };
  }
  // lib.optionalAttrs isNiri {
    # Disable DMS includes override; we have more specific options
    niri.includes.override = false;
  };
}
