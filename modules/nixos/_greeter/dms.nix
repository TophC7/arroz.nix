# DMS Greeter - niri as greeter compositor for niri, sway for hyprland
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

  hasNiri = desktop.niri.enable or false;
  hasHyprland = desktop.hyprland.enable or false;
  hasGnome = desktop.gnome.enable or false;

  dmsCompositor = if hasNiri then "niri" else "sway";

  niriPackage = arrozInputs.niri.packages.${system}.niri-unstable;
  sessionCommands = {
    hyprland-systemd = config._hyprlandSession.command;
    niri = "${niriPackage}/bin/niri-session";
  };

  defaultSession = config.services.displayManager.defaultSession;
  autoLoginCommand = sessionCommands.${defaultSession} or null;
in
{
  imports = [ arrozInputs.dankMaterialShell.nixosModules.greeter ];
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

  programs.dank-material-shell.greeter = {
    enable = lib.mkDefault true;
    compositor.name = lib.mkDefault dmsCompositor;
  };

  services.greetd.settings = lib.mkIf (greeter.autoLogin or false) {
    initial_session = {
      command = autoLoginCommand;
      user = host.user.name;
    };
  };

  # Sway needed as greeter compositor when Hyprland is the desktop
  environment.systemPackages = lib.mkIf hasHyprland [ pkgs.sway ];
}
