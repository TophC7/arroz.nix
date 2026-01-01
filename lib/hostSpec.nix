# arroz.nix Host Spec Extension
#
# Extends mix.nix host spec with desktop environment and greeter options.
# Used via mix.hostSpecExtensions for composable type extension.
#
# Usage:
#   mix.hosts.myhost = {
#     user = "toph";
#     desktop.hyprland.enable = true;
#     greeter = {
#       type = "dms";
#       autoLogin = true;
#     };
#   };
#
{ lib, ... }:

{
  options = {
    # ─────────────────────────────────────────────────────────────
    # DESKTOP ENVIRONMENTS
    # Multiple DEs can be enabled simultaneously.
    # If multiple are enabled, exactly one must be marked as default.
    # ─────────────────────────────────────────────────────────────

    desktop = {
      gnome = {
        enable = lib.mkEnableOption "GNOME desktop environment";
        default = lib.mkEnableOption "GNOME as the default/primary session";
      };

      hyprland = {
        enable = lib.mkEnableOption "Hyprland Wayland compositor";
        default = lib.mkEnableOption "Hyprland as the default/primary session";
      };

      niri = {
        enable = lib.mkEnableOption "Niri scrolling Wayland compositor";
        default = lib.mkEnableOption "Niri as the default/primary session";
      };
    };

    # ─────────────────────────────────────────────────────────────
    # GREETER / DISPLAY MANAGER
    # Independent of DE selection
    # ─────────────────────────────────────────────────────────────

    greeter = lib.mkOption {
      type = lib.types.submodule {
        options = {
          type = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.enum [
                "gdm" # GNOME Display Manager
                "dms" # DankMaterialShell (Quickshell-based)
                "tuigreet" # TUI greeter (greetd)
              ]
            );
            default = null;
            description = "Display manager/greeter to use. null = no greeter (TTY login).";
            example = "dms";
          };

          autoLogin = lib.mkEnableOption "automatic login for the primary user";
        };
      };
      default = { };
      description = "Greeter configuration";
    };
  };
}
