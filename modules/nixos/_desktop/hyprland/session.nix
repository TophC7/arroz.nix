# Hyprland Session Management
#
# Provides systemd-based session lifecycle for Hyprland, modeled after niri-session.
# This module creates:
# - hyprland-session script (entry point for greeters)
# - hyprland.service (systemd user service)
# - hyprland-shutdown.target (clean session shutdown)
#
# Any greeter (DMS, tuigreet, GDM) can launch Hyprland via the session command.
#
{
  arrozInputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPackage = arrozInputs.hyprland.packages.${system}.hyprland;

  # ── Session Script ──
  # Modeled after niri-session: proper systemd service lifecycle management
  sessionScript = pkgs.writeShellScriptBin "hyprland-session" ''
    # Re-exec with login shell if needed (matches niri-session behavior)
    if [ -n "$SHELL" ] &&
       grep -q "$SHELL" /etc/shells &&
       ! (echo "$SHELL" | grep -q "false") &&
       ! (echo "$SHELL" | grep -q "nologin"); then
      if [ "$1" != '-l' ]; then
        exec bash -c "exec -l '$SHELL' -c '$0 -l $*'"
      else
        shift
      fi
    fi

    # Check for already running session
    if ${pkgs.systemd}/bin/systemctl --user -q is-active hyprland.service; then
      echo 'A Hyprland session is already running.'
      exit 1
    fi

    # Reset failed state of all user units
    ${pkgs.systemd}/bin/systemctl --user reset-failed

    # Import the login manager environment
    ${pkgs.systemd}/bin/systemctl --user import-environment

    # Update dbus activation environment
    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
      dbus-update-activation-environment --all
    fi

    # Start Hyprland service and wait for it to terminate
    ${pkgs.systemd}/bin/systemctl --user --wait start hyprland.service

    # Cleanup: stop graphical session and unset environment
    ${pkgs.systemd}/bin/systemctl --user start --job-mode=replace-irreversibly hyprland-shutdown.target

    ${pkgs.systemd}/bin/systemctl --user unset-environment \
      WAYLAND_DISPLAY DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
  '';

  # ── Desktop Entry ──
  # Named "hyprland-systemd" to distinguish from default Hyprland session
  # This version uses proper systemd service lifecycle management
  desktopEntry = pkgs.stdenv.mkDerivation {
    pname = "hyprland-systemd-session";
    version = "1.0";
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/wayland-sessions
      cat > $out/share/wayland-sessions/hyprland-systemd.desktop <<EOF
      [Desktop Entry]
      Name=Hyprland (systemd)
      Comment=Hyprland with systemd session management
      Exec=${sessionScript}/bin/hyprland-session
      Type=Application
      DesktopNames=Hyprland
      EOF
    '';
    passthru.providedSessions = [ "hyprland-systemd" ];
  };
in
{
  # Export session interface for greeters
  options._hyprlandSession = lib.mkOption {
    type = lib.types.attrs;
    default = {
      package = hyprlandPackage;
      script = sessionScript;
      command = "${sessionScript}/bin/hyprland-session";
      desktopEntry = desktopEntry;
    };
    internal = true;
    description = "Hyprland session components for use by greeter modules";
  };

  config = {
    # Systemd User Service
    systemd.user.services.hyprland = {
      description = "Hyprland - A dynamic tiling Wayland compositor";
      bindsTo = [ "graphical-session.target" ];
      before = [
        "graphical-session.target"
        "xdg-desktop-autostart.target"
      ];
      wants = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
      after = [ "graphical-session-pre.target" ];
      serviceConfig = {
        Type = "simple";
        Slice = "session.slice";
        ExecStart = "${hyprlandPackage}/bin/Hyprland";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Shutdown Target
    systemd.user.targets.hyprland-shutdown = {
      description = "Shutdown Hyprland session";
      conflicts = [
        "graphical-session.target"
        "graphical-session-pre.target"
      ];
      after = [
        "graphical-session.target"
        "graphical-session-pre.target"
      ];
    };

    # Session Registration
    services.displayManager.sessionPackages = [ desktopEntry ];
    environment.systemPackages = [ desktopEntry ];
  };
}
