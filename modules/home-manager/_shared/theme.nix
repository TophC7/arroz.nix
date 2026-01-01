# Stylix integration - wires mix.nix theme spec to stylix
#
# This module consumes config.theme.* from mix.nix's theme module
# and applies it to stylix. The theme spec is defined per-host.
#
# mix.nix theme module provides:
#   - theme.image, theme.polarity
#   - theme.icon, theme.pointer, theme.fonts
#   - theme.base16.generate (matugen integration)
#   - theme.generated.base16Scheme (read-only output)
#
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.theme;
in
{
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.mix-nix.homeManagerModules.theme
  ];

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = lib.mkDefault true;
      autoEnable = lib.mkDefault true;
      image = cfg.image;
      polarity = cfg.polarity;

      # Wire fonts from theme spec (if defined)
      fonts = lib.mkIf (cfg.fonts != null) cfg.fonts;

      # Wire icons from theme spec
      icons = lib.mkIf (cfg.icon != null) {
        enable = lib.mkDefault true;
        package = cfg.icon.package;
        dark = cfg.icon.name;
        light = cfg.icon.name;
      };

      # Wire base16 scheme from theme spec
      base16Scheme = lib.mkIf (cfg.generated.base16Scheme != null) {
        yaml = cfg.generated.base16Scheme;
        use-ifd = "auto";
      };

      targets = {
        gnome = {
          enable = lib.mkDefault true;
          useWallpaper = lib.mkDefault true;
        };
        vscode.enable = lib.mkDefault false;
        qt = {
          enable = lib.mkDefault true;
          platform = lib.mkDefault "qtct";
        };
      };
    };

    # Wire cursor from theme spec
    home.pointerCursor = lib.mkIf (cfg.pointer != null) {
      gtk.enable = lib.mkDefault true;
      package = cfg.pointer.package;
      name = cfg.pointer.name;
      size = cfg.pointer.size;
    };

    gtk.enable = lib.mkDefault true;
  };
}
