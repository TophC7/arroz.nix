# Hyprland Home Manager Configuration
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  hyprscrolling = inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling;
in
{
  imports = lib.fs.scanPaths ./.;

  # Hyprland home-manager configuration
  wayland.windowManager.hyprland = {
    enable = lib.mkDefault true;

    # Use the package from NixOS module (set to null)
    package = lib.mkDefault null;

    # CRITICAL: Disable systemd integration when using UWSM
    systemd.enable = lib.mkDefault false;

    # Plugins for niri-like scrolling layout and overview
    plugins = lib.mkDefault [
      hyprscrolling # Column-based scrolling layout like niri
    ];

    settings = {
      # Input configuration
      input = {
        kb_layout = lib.mkDefault "us";
        kb_options = lib.mkDefault "terminate:ctrl_alt_bksp,compose:menu";

        follow_mouse = lib.mkDefault 2;

        touchpad = {
          natural_scroll = lib.mkDefault true;
          tap-to-click = lib.mkDefault true;
          disable_while_typing = lib.mkDefault true;
        };

        sensitivity = lib.mkDefault 0;
      };

      # General settings
      general = {
        gaps_in = lib.mkDefault 4;
        gaps_out = lib.mkDefault 8;
        border_size = lib.mkDefault 2;
        layout = lib.mkDefault "scrolling"; # Use hyprscrolling for niri-like behavior
      };

      # Hyprscrolling plugin configuration (niri-like scrolling layout)
      plugin = {
        hyprscrolling = {
          column_width = lib.mkDefault 0.5; # Default column width as fraction of monitor
          explicit_column_widths = lib.mkDefault "0.333, 0.5, 0.667, 1.0"; # Preset widths for cycling
          fullscreen_on_one_column = lib.mkDefault false;
          focus_fit_method = lib.mkDefault 1; # 0 = center, 1 = fit
          follow_focus = lib.mkDefault true; # Auto-scroll to focused window
        };
      };

      # Decoration
      decoration = {
        rounding = lib.mkDefault 10;
        rounding_power = lib.mkDefault 4.0;
        active_opacity = lib.mkDefault 0.98;
        inactive_opacity = lib.mkDefault 0.92;
        fullscreen_opacity = lib.mkDefault 1.0;
        dim_inactive = lib.mkDefault true;
        dim_strength = lib.mkDefault 0.2;

        blur = {
          enabled = lib.mkDefault true;
          size = lib.mkDefault 5;
          passes = lib.mkDefault 2;
          new_optimizations = lib.mkDefault true;
          ignore_opacity = lib.mkDefault true;
          noise = lib.mkDefault 0.15;
          popups = lib.mkDefault true;
        };

        shadow = {
          enabled = lib.mkDefault true;
          range = lib.mkDefault 30;
          render_power = lib.mkDefault 2;
          scale = lib.mkDefault 1.5;
        };
      };

      # Animations
      animations = {
        enabled = lib.mkDefault true;
        bezier = lib.mkDefault "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = lib.mkDefault [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      group = {
        drag_into_group = lib.mkDefault 2;
        merge_groups_on_drag = lib.mkDefault true;
        groupbar = {
          enabled = lib.mkDefault true;
          height = lib.mkDefault 12;
        };
      };

      # Layout configuration
      dwindle = {
        pseudotile = lib.mkDefault false;
        force_split = lib.mkDefault 0;
        smart_split = lib.mkDefault true;
        split_bias = lib.mkDefault 1;
      };

      master = {
        new_status = lib.mkDefault "master";
      };

      # Misc settings
      misc = {
        force_default_wallpaper = lib.mkDefault 0;
        disable_hyprland_logo = lib.mkDefault true;
      };

      # XWayland settings
      xwayland = {
        force_zero_scaling = lib.mkDefault true;
      };

      # Environment variables
      env = lib.mkDefault [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
      ];

      # Monitor configuration from config.monitors
      monitor = lib.forEach config.monitors (
        m:
        let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
          scale = toString m.scale;
          transform = toString m.transform;
          vrr = if m.vrr or false then ",vrr,1" else "";
        in
        "${m.name},${
          if m.enabled then "${resolution},${position},${scale},transform,${transform}${vrr}" else "disable"
        }"
      );
    };
  };
}
