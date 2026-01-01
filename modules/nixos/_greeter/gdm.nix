# GNOME Display Manager (GDM) configuration
{
  host,
  lib,
  ...
}:

let
  greeter = host.greeter or { };
in
{
  services.displayManager = {
    gdm = {
      enable = lib.mkDefault true;
      wayland = lib.mkDefault true;
    };

    autoLogin = lib.mkIf (greeter.autoLogin or false) {
      enable = true;
      user = host.user.name;
    };
  };
}
