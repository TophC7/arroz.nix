# Nautilus file manager and related tools
{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    code-nautilus
    file-roller
    gnome-epub-thumbnailer
    nautilus
    nautilus-python
    papers
    sushi
    turtle
  ];

  # Enable user file access
  services = {
    gvfs.enable = true;
    udisks2.enable = true;
  };

  programs.nautilus-open-any-terminal.enable = lib.mkDefault true;
}
