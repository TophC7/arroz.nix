# Niri Compositor NixOS Configuration
{
  arrozInputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    arrozInputs.niri.nixosModules.niri
    ../_wayland.nix # Common Wayland infrastructure
  ]
  ++ lib.fs.scanPaths ./.;

  nixpkgs.overlays = [ arrozInputs.niri.overlays.niri ];

  # Niri Compositor
  programs.niri = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.niri-unstable;
  };

  # XDG Portal (Niri-specific)
  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # GTK file picker
      xdg-desktop-portal-gnome # GNOME apps compatibility
    ];
    config = {
      niri = {
        default = lib.mkDefault [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Screenshot" = lib.mkDefault [ "gnome" ];
        "org.freedesktop.impl.portal.Screencast" = lib.mkDefault [ "gnome" ];
      };
      common.default = lib.mkDefault [
        "gnome"
        "gtk"
      ];
    };
  };

  # Niri-specific Overrides
  # DMS handles polkit agent - disable niri-flake's built-in to avoid conflicts
  systemd.user.services.niri-flake-polkit.enable = lib.mkDefault false;
}
