# Hyprland Compositor NixOS Configuration
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPackage = inputs.hyprland.packages.${system}.hyprland;
in
{
  imports = [
    ../_wayland.nix # Common Wayland infrastructure
  ]
  ++ lib.fs.scanPaths ./.;

  # ══════════════════════════════════════════════════════════════════════════
  # Hyprland Compositor
  # ══════════════════════════════════════════════════════════════════════════
  programs.hyprland = {
    enable = lib.mkDefault true;
    withUWSM = lib.mkDefault false;
    xwayland.enable = lib.mkDefault true;
    package = hyprlandPackage;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Hyprland Cachix
  # ══════════════════════════════════════════════════════════════════════════
  nix.settings = {
    substituters = lib.mkDefault [ "https://hyprland.cachix.org" ];
    trusted-public-keys = lib.mkDefault [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Hyprland-specific Packages
  # ══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    cliphist # Clipboard manager for Hyprland
  ];

  # ══════════════════════════════════════════════════════════════════════════
  # XDG Portal (Hyprland-specific)
  # ══════════════════════════════════════════════════════════════════════════
  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = lib.mkDefault [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      hyprland.default = lib.mkDefault [
        "hyprland"
        "gtk"
      ];
      common.default = lib.mkDefault [
        "hyprland"
        "gtk"
      ];
    };
  };
}
