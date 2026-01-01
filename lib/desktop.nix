# Desktop Detection Library
#
# Provides helpers for detecting enabled desktops and determining the default.
# Used by greeter modules and shared assertions.
#
{ lib }:

{
  # Build desktop detection from host spec
  # Returns: { desktops, enabled, defaults, default, defaultName, sessionNames }
  mkDesktopInfo =
    {
      host,
      # List of { name, session } for desktops to include
      # session can be null if not needed (e.g., for assertions only)
      supportedDesktops ? [
        { name = "hyprland"; }
        { name = "niri"; }
        { name = "gnome"; }
      ],
      # Optional: function to get session command for a desktop name
      getSession ? (_name: null),
    }:
    let
      desktop = host.desktop or { };

      # Build desktop list with enabled/default status
      desktops = map (
        d:
        let
          de = desktop.${d.name} or { };
        in
        {
          inherit (d) name;
          enabled = de.enable or false;
          isDefault = de.default or false;
          session = d.session or (getSession d.name);
        }
      ) supportedDesktops;

      enabled = lib.filter (d: d.enabled) desktops;
      defaults = lib.filter (d: d.isDefault) desktops;

      # The default desktop: implicit if only one enabled, explicit otherwise
      default =
        if lib.length enabled == 1 then
          lib.head enabled
        else if lib.length defaults == 1 then
          lib.head defaults
        else
          null;

      defaultName = if default != null then default.name else null;

      # Map of desktop name -> NixOS session name (for services.displayManager.defaultSession)
      sessionNames = {
        hyprland = "hyprland-systemd"; # Custom session with systemd lifecycle
        niri = "niri";
        gnome = "gnome";
      };
    in
    {
      inherit
        desktops
        enabled
        defaults
        default
        defaultName
        sessionNames
        ;
    };

  # Build assertions for desktop default validation
  mkDesktopAssertions =
    { enabled, defaults }:
    [
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
}
