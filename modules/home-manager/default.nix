# arroz.nix Home Manager module
#
# Conditionally imports desktop and greeter modules based on host spec.
# This module is auto-injected via coreHomeModules - no manual import needed.
#
{ host, lib, ... }:

let
  desktop = host.desktop or { };
  greeter = host.greeter or { };

  # Data-driven desktop detection
  desktopNames = [ "gnome" "hyprland" "niri" ];
  hasDesktop = lib.any (name: desktop.${name}.enable or false) desktopNames;

  # DMS shell (panel/widgets) is used with hyprland/niri (not GNOME)
  # This is separate from greeter.type - DMS shell runs regardless of greeter choice
  needsDmsShell = lib.any (name: desktop.${name}.enable or false) [ "hyprland" "niri" ];
in
{
  imports = lib.flatten [
    # ── Desktop Environments ──
    (lib.optional (desktop.gnome.enable or false) ./_desktop/gnome)
    (lib.optional (desktop.hyprland.enable or false) ./_desktop/hyprland)
    (lib.optional (desktop.niri.enable or false) ./_desktop/niri)

    # ── DMS Shell ──
    # DMS shell (panel/widgets) for Hyprland/Niri
    (lib.optional needsDmsShell ./_shell/dms)

    # ── Shared ──
    # Only loaded when any desktop is enabled
    (lib.optional hasDesktop ./_shared)
  ];
}
