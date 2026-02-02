# Desktop Session Configuration
#
# Shared module that:
# - Validates desktop.*.default configuration
# - Sets services.displayManager.defaultSession
#
# Applied regardless of which greeter is used.
#
{
  host,
  lib,
  ...
}:

let
  desktop = host.desktop or { };

  # All desktops for validation
  desktops = [
    {
      name = "hyprland";
      enabled = desktop.hyprland.enable or false;
      isDefault = desktop.hyprland.default or false;
      session = "hyprland"; # UWSM is enabled but session name stays "hyprland"
    }
    {
      name = "niri";
      enabled = desktop.niri.enable or false;
      isDefault = desktop.niri.default or false;
      session = "niri";
    }
    {
      name = "gnome";
      enabled = desktop.gnome.enable or false;
      isDefault = desktop.gnome.default or false;
      session = "gnome";
    }
  ];

  enabled = lib.filter (d: d.enabled) desktops;
  defaults = lib.filter (d: d.isDefault) desktops;

  # The default desktop: implicit if only one enabled, explicit otherwise
  defaultDesktop =
    if lib.length enabled == 1 then
      lib.head enabled
    else if lib.length defaults == 1 then
      lib.head defaults
    else
      null;

  hasAnyDesktop = enabled != [ ];
in
{
  # Desktop Default Validation (applies to all hosts with desktops)
  assertions = lib.mkIf hasAnyDesktop [
    {
      assertion = lib.length enabled <= 1 || lib.length defaults == 1;
      message = ''
        Multiple desktops enabled (${lib.concatMapStringsSep ", " (d: d.name) enabled}) but no default set.
        Add: desktop.<name>.default = true
      '';
    }
    {
      assertion = lib.length defaults <= 1;
      message = ''
        Multiple desktops marked as default: ${lib.concatMapStringsSep ", " (d: d.name) defaults}
        Only one can be default.
      '';
    }
    {
      assertion = lib.all (d: d.enabled) defaults;
      message = ''
        Desktop marked as default but not enabled: ${
          lib.concatMapStringsSep ", " (d: d.name) (lib.filter (d: !d.enabled) defaults)
        }
      '';
    }
  ];

  # Set default session for display managers
  services.displayManager.defaultSession = lib.mkIf (defaultDesktop != null) (
    lib.mkDefault defaultDesktop.session
  );
}
