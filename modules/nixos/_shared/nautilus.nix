# Nautilus file manager and related tools
{ pkgs, lib, ... }:
{
  environment.systemPackages = lib.mkDefault (
    with pkgs;
    [
      code-nautilus
      file-roller
      gnome-epub-thumbnailer
      nautilus
      papers
      sushi
      turtle
    ]
  );

  programs.nautilus-open-any-terminal.enable = lib.mkDefault true;
}
