# DMS Plugin Definitions
# NOTE: This file is prefixed with _ to exclude from auto-discovery
{
  arrozInputs,
  lib,
  pkgs,
  ...
}:
let
  mkPlugin =
    {
      pname,
      src,
      subdir ? null,
      description,
      homepage,
      license,
    }:
    pkgs.stdenv.mkDerivation {
      inherit pname src;
      version = src.shortRev or src.lastModifiedDate or "unstable";

      installPhase =
        let
          srcPath = if subdir != null then "${src}/${subdir}" else src;
        in
        ''
          mkdir -p $out
          cp -r ${srcPath}/* $out/
        '';

      meta = { inherit description homepage license; };
    };
in
{
  dankActionsPlugin = mkPlugin {
    pname = "dms-dank-actions";
    src = arrozInputs.dms-plugin-actions;
    subdir = "DankActions";
    description = "DankMaterialShell DankActions plugin";
    homepage = "https://github.com/AvengeMedia/dms-plugins";
    license = lib.licenses.mit;
  };

  easyEffectsPlugin = mkPlugin {
    pname = "dms-easyeffects";
    src = arrozInputs.dms-plugin-easyeffects;
    description = "DankMaterialShell EasyEffects plugin for audio profile switching";
    homepage = "https://github.com/jonkristian/dms-easyeffects";
    license = lib.licenses.gpl3Only;
  };

  displaySettingsPlugin = mkPlugin {
    pname = "dms-display-settings";
    src = arrozInputs.dms-plugin-display-settings;
    subdir = "displaySettings";
    description = "DankMaterialShell display settings plugin for screen management";
    homepage = "https://github.com/Lucyfire/dms-plugins";
    license = lib.licenses.mit;
  };

  nixMonitorPlugin = mkPlugin {
    pname = "dms-nix-monitor";
    src = arrozInputs.dms-plugin-nix-monitor;
    description = "DankMaterialShell Nix update monitor widget";
    homepage = "https://github.com/antonjah/nix-monitor";
    license = lib.licenses.mit;
  };
}
