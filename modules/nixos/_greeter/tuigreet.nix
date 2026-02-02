# TUIGreet - Terminal UI Greeter
#
# Minimal TUI-based greeter using greetd + tuigreet.
# Works with all desktop environments.
#
{
  arrozInputs,
  config,
  host,
  lib,
  pkgs,
  ...
}:

let
  desktop = host.desktop or { };
  greeter = host.greeter or { };
  system = pkgs.stdenv.hostPlatform.system;

  # ── Session Commands ──
  niriPackage = arrozInputs.niri.packages.${system}.niri-unstable;
  sessionCommands = {
    hyprland = config._hyprlandSession.command;
    niri = "${niriPackage}/bin/niri-session";
    gnome = "gnome-session"; # Provided by GNOME, in PATH
  };

  # Use defaultSession from _shared/desktop-session.nix
  defaultSession = config.services.displayManager.defaultSession;
  sessionCommand = sessionCommands.${defaultSession} or "bash";
in
{
  # TUIgreet-specific Assertions
  # (Default validation is handled by _shared/desktop-session.nix)
  assertions = [
    {
      assertion =
        (desktop.hyprland.enable or false)
        || (desktop.niri.enable or false)
        || (desktop.gnome.enable or false);
      message = "tuigreet requires at least one desktop enabled.";
    }
  ];

  # Greetd Configuration
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd \"${sessionCommand}\"";
        user = "greeter";
      };
    }
    // lib.optionalAttrs (greeter.autoLogin or false) {
      initial_session = {
        command = sessionCommand;
        user = host.user.name;
      };
    };
  };

  # System Packages
  environment.systemPackages = [ pkgs.tuigreet ];
}
