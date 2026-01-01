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

  # DMS home config only needed for hyprland/niri (not GNOME)
  hasDmsDesktop = lib.any (name: desktop.${name}.enable or false) [ "hyprland" "niri" ];
  needsDmsHome = (greeter.type or null == "dms") && hasDmsDesktop;
in
{
  imports = lib.flatten [
    # ── Desktop Environments ──
    (lib.optional (desktop.gnome.enable or false) ./_desktop/gnome)
    (lib.optional (desktop.hyprland.enable or false) ./_desktop/hyprland)
    (lib.optional (desktop.niri.enable or false) ./_desktop/niri)

    # ── Greeters ──
    # DMS has home-manager config (Quickshell, Vicinae, etc.)
    (lib.optional needsDmsHome ./_greeter/dms)

    # ── Shared ──
    # Only loaded when any desktop is enabled
    (lib.optional hasDesktop ./_shared)
  ];
}
