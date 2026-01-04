# Hyprland DMS Integration
# Sources DMS-managed outputs config for runtime monitor management
#
# File sourced:
#   - ~/.config/hypr/dms/outputs.conf - Monitor configuration (editable at runtime)
#
{
  host,
  lib,
  pkgs,
  ...
}:
let
  dms = host.desktop.hyprland.dms or { };
  sourceOutputs = dms.sourceOutputs or false;

  # Outputs placeholder file - created via Nix
  outputsPlaceholder = pkgs.writeText "dms-outputs-placeholder.conf" ''
    # DMS Outputs Configuration
    # This file is managed by DMS at runtime for monitor configuration
    # Edit via DMS settings or modify directly - changes persist across rebuilds

    monitor = , preferred, auto, auto
  '';
in
{
  wayland.windowManager.hyprland = lib.mkIf sourceOutputs {
    extraConfig = ''
      # Source DMS outputs (monitor config)
      source = ~/.config/hypr/dms/outputs.conf
    '';
  };

  # Create placeholder file if it doesn't exist
  home.activation = lib.mkIf sourceOutputs {
    createDmsOutputsConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/hypr/dms"
      [ -f "$HOME/.config/hypr/dms/outputs.conf" ] || cp ${outputsPlaceholder} "$HOME/.config/hypr/dms/outputs.conf"
    '';
  };
}
