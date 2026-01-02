# GNOME Home Manager Configuration
{ lib, ... }:
{
  imports = lib.flatten [
    (lib.fs.scanPaths ./.)
    ../_wayland.nix
  ];
}
