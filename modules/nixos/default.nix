# arroz.nix NixOS module
#
# Conditionally imports desktop and greeter modules based on host spec.
# This module is auto-injected via coreModules - no manual import needed.
#
{ host, lib, ... }:

let
  desktop = host.desktop or { };
  greeter = host.greeter or { };

  desktopNames = [
    "gnome"
    "hyprland"
    "niri"
  ];

  hasDesktop = lib.any (name: desktop.${name}.enable or false) desktopNames;
in
{
  imports = lib.flatten [
    # ── Desktop Environments ──
    (lib.optional (desktop.gnome.enable or false) ./_desktop/gnome)
    (lib.optional (desktop.hyprland.enable or false) ./_desktop/hyprland)
    (lib.optional (desktop.niri.enable or false) ./_desktop/niri)

    # ── Greeters ──
    (lib.optional (greeter.type or null == "gdm") ./_greeter/gdm.nix)
    (lib.optional (greeter.type or null == "dms") ./_greeter/dms.nix)
    (lib.optional (greeter.type or null == "tuigreet") ./_greeter/tuigreet.nix)

    # ── Shared ──
    # Only loaded when any desktop is enabled
    (lib.optional hasDesktop ./_shared)
  ];
}
