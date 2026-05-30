# arroz.nix Home Manager module
#
# Conditionally imports desktop and greeter modules based on host spec.
# This module is auto-injected via coreHomeModules - no manual import needed.
#
{ host, lib, ... }:

let
  desktop = host.desktop or { };

  # Data-driven desktop detection
  desktopNames = [ "gnome" "niri" ];
  hasDesktop = lib.any (name: desktop.${name}.enable or false) desktopNames;

  # DMS shell (panel/widgets) is used with Niri (not GNOME)
  # This is separate from greeter.type - DMS shell runs regardless of greeter choice
  needsDmsShell = desktop.niri.enable or false;
in
{
  imports = lib.flatten [
    # ── Desktop Environments ──
    (lib.optional (desktop.gnome.enable or false) ./_desktop/gnome)
    (lib.optional (desktop.niri.enable or false) ./_desktop/niri)

    # ── DMS Shell ──
    # DMS shell (panel/widgets) for Niri
    (lib.optional needsDmsShell ./_shell/dms)

    # ── Shared ──
    # Only loaded when any desktop is enabled
    (lib.optional hasDesktop ./_shared)
  ];
}
