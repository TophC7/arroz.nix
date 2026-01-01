# DankMaterialShell (DMS) Greeter
#
# Unified DMS greeter configuration for Hyprland and Niri.
# - Niri: Uses niri as the greeter compositor
# - Hyprland: Uses sway as greeter compositor (DMS has issues using hyprland directly when using hyprland as actual DE)
#
# NOTE: DMS greeter compositor != desktop session
# The greeter runs on niri/sway, then launches the actual desktop session.
#
{
  config,
  host,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  desktop = host.desktop or { };
  greeter = host.greeter or { };
  system = pkgs.stdenv.hostPlatform.system;

  # ── Desktop Detection (DMS only supports Hyprland/Niri) ──
  hasNiri = desktop.niri.enable or false;
  hasHyprland = desktop.hyprland.enable or false;
  hasGnome = desktop.gnome.enable or false;

  # Greeter compositor: niri preferred (for the greeter UI, not the session)
  dmsCompositor = if hasNiri then "niri" else "sway";

  # ── Session Commands (keyed by NixOS session name) ──
  niriPackage = inputs.niri.packages.${system}.niri-unstable;

  sessionCommands = {
    hyprland-systemd = config._hyprlandSession.command;
    niri = "${niriPackage}/bin/niri-session";
  };

  # Auto-login uses defaultSession from _shared/desktop-session.nix
  defaultSession = config.services.displayManager.defaultSession;
  autoLoginCommand = sessionCommands.${defaultSession} or null;
in
{
  imports = [ inputs.dankMaterialShell.nixosModules.greeter ];

  # ══════════════════════════════════════════════════════════════════════════
  # DMS-specific Assertions
  # (Default validation is handled by _shared/desktop-session.nix)
  # ══════════════════════════════════════════════════════════════════════════
  assertions = [
    {
      assertion = hasNiri || hasHyprland;
      message = "DMS greeter requires Hyprland or Niri. Enable: desktop.hyprland.enable or desktop.niri.enable";
    }
    {
      assertion = !hasGnome;
      message = "DMS greeter is incompatible with GNOME. Use greeter.type = \"gdm\" instead.";
    }
  ];

  # ══════════════════════════════════════════════════════════════════════════
  # DMS Greeter Configuration
  # ══════════════════════════════════════════════════════════════════════════
  programs.dank-material-shell.greeter = {
    enable = lib.mkDefault true;

    compositor = {
      name = lib.mkDefault dmsCompositor;
      customConfig = lib.mkDefault "";
    };

    logs = {
      save = lib.mkDefault false;
      path = lib.mkDefault "/var/log/dms-greeter.log";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Auto-login Configuration
  # ══════════════════════════════════════════════════════════════════════════
  services.greetd.settings = lib.mkIf (greeter.autoLogin or false) {
    initial_session = {
      command = autoLoginCommand;
      user = host.user.name;
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # System Packages
  # ══════════════════════════════════════════════════════════════════════════
  # Sway needed as greeter compositor when Hyprland is the desktop
  environment.systemPackages = lib.mkIf hasHyprland [ pkgs.sway ];
}
