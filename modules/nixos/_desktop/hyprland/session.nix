# Hyprland Session - UWSM Integration
#
# With UWSM enabled, session management is handled automatically.
# This module just exports the session interface for greeters.
#
{
  arrozInputs,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPackage = arrozInputs.hyprland.packages.${system}.hyprland;
in
{
  # Export session interface for greeters
  # UWSM handles the actual session management
  options._hyprlandSession = lib.mkOption {
    type = lib.types.attrs;
    default = {
      package = hyprlandPackage;
      # UWSM session command - proper environment and systemd integration
      command = "uwsm start hyprland-uwsm.desktop";
    };
    internal = true;
    description = "Hyprland session components for use by greeter modules";
  };
}
