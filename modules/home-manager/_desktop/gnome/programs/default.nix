# GNOME-specific programs
# Add additional GNOME program configurations here
{ lib, ... }:
{
  imports = lib.fs.scanPaths ./.;
}
