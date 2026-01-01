# Ambxst - An Axtremely customizable shell for Hyprland
# https://github.com/Axenide/Ambxst
#
# Installed as standalone package for testing - NOT autostarted
# Run manually with: ambxst
#
# NOTE: This file is prefixed with _ to exclude from auto-discovery.
# Import explicitly if you want to use Ambxst.
#
{
  arrozInputs,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  ambxst = arrozInputs.ambxst.packages.${system}.default;
in
{
  # Install Ambxst package with lower priority to avoid conflicts
  # (Ambxst bundles ffmpeg which conflicts with ffmpeg-full)
  home.packages = [ (lib.lowPrio ambxst) ];

  # Set QML import paths for Ambxst/Quickshell
  home.sessionVariables = {
    QML2_IMPORT_PATH = "${ambxst}/lib/qt-6/qml";
    QML_IMPORT_PATH = "${ambxst}/lib/qt-6/qml";
  };

  # NOTE: Ambxst is NOT autostarted - run manually to test
  # To autostart, add "ambxst" to exec-once in your config
}
