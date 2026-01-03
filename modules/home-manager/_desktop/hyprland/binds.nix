# Default Hyprland keybindings
# These are minimal defaults - hosts can override in home/hosts/<hostname>/config/hyprland/
{
  arrozInputs,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprnavi = lib.getExe arrozInputs.hyprnavi-psm.packages.${system}.default;
in
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = lib.mkDefault "SUPER";

    bind = lib.mkDefault [
      # Application launchers (minimal defaults)
      "$mod, Return, exec, ${lib.getExe pkgs.ghostty}"

      # Window management
      "$mod, Q, killactive"
      "$mod, F, fullscreen"
      "$mod, Space, togglefloating"

      # Focus movement using hyprnavi
      # -p: position-based detection for scrolling layouts (hyprscrolling)
      # -m: navigate to adjacent monitor at screen edges
      # L/R: Move across monitors | U/D: Move across workspaces (wraps by default)
      "$mod, left, exec, ${hyprnavi} l -pm"
      "$mod, right, exec, ${hyprnavi} r -pm"
      "$mod, up, exec, ${hyprnavi} u -p"
      "$mod, down, exec, ${hyprnavi} d -p"

      # Window movement using hyprnavi
      # -ps: position-based + swap = column-aware movement via layoutmsg
      # L/R: Move window across monitors | U/D: Move across workspaces (wraps)
      "$mod SHIFT, left, exec, ${hyprnavi} l -psm"
      "$mod SHIFT, right, exec, ${hyprnavi} r -psm"
      "$mod SHIFT, up, exec, ${hyprnavi} u -ps"
      "$mod SHIFT, down, exec, ${hyprnavi} d -ps"

      # Workspace switching (1-10) using split-monitor-workspaces
      "$mod, 1, split-workspace, 1"
      "$mod, 2, split-workspace, 2"
      "$mod, 3, split-workspace, 3"
      "$mod, 4, split-workspace, 4"
      "$mod, 5, split-workspace, 5"
      "$mod, 6, split-workspace, 6"
      "$mod, 7, split-workspace, 7"
      "$mod, 8, split-workspace, 8"
      "$mod, 9, split-workspace, 9"
      "$mod, 0, split-workspace, 10"

      # Move window to workspace using split-monitor-workspaces
      "$mod SHIFT, 1, split-movetoworkspace, 1"
      "$mod SHIFT, 2, split-movetoworkspace, 2"
      "$mod SHIFT, 3, split-movetoworkspace, 3"
      "$mod SHIFT, 4, split-movetoworkspace, 4"
      "$mod SHIFT, 5, split-movetoworkspace, 5"
      "$mod SHIFT, 6, split-movetoworkspace, 6"
      "$mod SHIFT, 7, split-movetoworkspace, 7"
      "$mod SHIFT, 8, split-movetoworkspace, 8"
      "$mod SHIFT, 9, split-movetoworkspace, 9"
      "$mod SHIFT, 0, split-movetoworkspace, 10"

      # Scroll through workspaces on current monitor
      "$mod, mouse_down, split-workspace, e+1"
      "$mod, mouse_up, split-workspace, e-1"
    ];

    # Mouse bindings
    bindm = lib.mkDefault [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # Media keys (repeatable)
    bindel = lib.mkDefault [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
    ];

    # Media keys (non-repeatable)
    bindl = lib.mkDefault [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
      ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
    ];
  };
}
