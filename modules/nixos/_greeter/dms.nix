# DMS Greeter - niri as greeter compositor
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
  hasGnome = desktop.gnome.enable or false;

  niriPackage = arrozInputs.niri.packages.${system}.niri-unstable;
  sessionCommands = {
    niri = "${niriPackage}/bin/niri-session";
  };

  defaultSession = config.services.displayManager.defaultSession;
  autoLoginCommand = sessionCommands.${defaultSession} or null;
in
{
  imports = [ arrozInputs.dankMaterialShell.nixosModules.greeter ];
  assertions = [
    {
      assertion = hasNiri;
      message = "DMS greeter requires Niri. Enable: desktop.niri.enable";
    }
    {
      assertion = !hasGnome;
      message = "DMS greeter is incompatible with GNOME. Use greeter.type = \"gdm\" instead.";
    }
  ];

  programs.dank-material-shell.greeter = {
    enable = lib.mkDefault true;
    compositor.name = lib.mkDefault "niri";
    configHome = lib.mkDefault "/home/${host.user.name}";
  };

  services.greetd.settings = lib.mkIf (greeter.autoLogin or false) {
    initial_session = {
      command = autoLoginCommand;
      user = host.user.name;
    };
  };

}
