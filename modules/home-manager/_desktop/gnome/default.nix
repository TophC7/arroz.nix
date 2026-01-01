# GNOME Home Manager Configuration
{ lib, ... }:
{
  imports = lib.fs.scanPaths ./.;
}
