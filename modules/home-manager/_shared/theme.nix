# Stylix integration — wires mix.nix theme spec to stylix
#
# When DMS is active, terminal targets (ghostty, fish) are handled by
# dank16-generated theme files instead of stylix.
#
{
  arrozInputs,
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.theme;

  desktop = host.desktop or { };
  needsDmsShell = lib.any (name: desktop.${name}.enable or false) [
    "hyprland"
    "niri"
  ];

  # Dank16 terminal themes — only when DMS is active and base16 scheme exists
  dank16Lib = (import ../../../lib/dank16.nix { inherit lib; }).dank16;
  system = pkgs.stdenv.hostPlatform.system;
  useDank16 = cfg.enable && needsDmsShell && cfg.generated.base16Scheme != null;

  dank16Themes =
    if useDank16 then
      dank16Lib.mkTerminalThemes {
        inherit pkgs;
        dmsPackage = arrozInputs.dankMaterialShell.packages.${system}.default;
        matugenBase16Scheme = cfg.generated.base16Scheme;
        polarity = cfg.polarity;
      }
    else
      null;
in
{
  imports = [
    arrozInputs.stylix.homeModules.stylix
    arrozInputs.mix-nix.homeManagerModules.theme
  ];

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = lib.mkDefault true;
      autoEnable = lib.mkDefault true;
      image = cfg.image;
      polarity = cfg.polarity;

      fonts = lib.mkIf (cfg.fonts != null) cfg.fonts;

      icons = lib.mkIf (cfg.icon != null) {
        enable = lib.mkDefault true;
        package = cfg.icon.package;
        dark = cfg.icon.name;
        light = cfg.icon.name;
      };

      base16Scheme = lib.mkIf (cfg.generated.base16Scheme != null) {
        yaml = cfg.generated.base16Scheme;
        use-ifd = "auto";
      };

      targets = {
        dank-material-shell.enable = lib.mkDefault false;
        gnome = {
          enable = lib.mkDefault true;
          useWallpaper = lib.mkDefault true;
        };
        qt = {
          enable = lib.mkDefault true;
          platform = lib.mkDefault "qtct";
        };
        vscode.enable = lib.mkDefault false;

        # Disable stylix for terminals when dank16 handles them
        ghostty.enable = lib.mkIf useDank16 false;
        fish.enable = lib.mkIf useDank16 false;
      };
    };

    # Dank16 terminal theme files
    home.file = lib.mkIf useDank16 {
      ".config/ghostty/themes/dank16".source = "${dank16Themes}/ghostty-theme";
    };

    programs.ghostty.settings.theme = lib.mkIf useDank16 (lib.mkForce "dank16");

    programs.fish.interactiveShellInit = lib.mkIf useDank16 (
      builtins.readFile "${dank16Themes}/fish-colors.fish"
    );

    home.pointerCursor = lib.mkIf (cfg.pointer != null) {
      gtk.enable = lib.mkDefault true;
      package = cfg.pointer.package;
      name = cfg.pointer.name;
      size = cfg.pointer.size;
    };

    gtk.enable = lib.mkDefault true;
  };
}
