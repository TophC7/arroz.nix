# DMS Plugin Definitions
# NOTE: This file is prefixed with _ to exclude from auto-discovery
{
  arrozInputs,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;

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
    src = arrozInputs.dms-actions;
    subdir = "DankActions";
    description = "DankMaterialShell DankActions plugin";
    homepage = "https://github.com/AvengeMedia/dms-plugins";
    license = lib.licenses.mit;
  };

  easyEffectsPlugin = mkPlugin {
    pname = "dms-easyeffects";
    src = arrozInputs.dms-easyeffects;
    description = "DankMaterialShell EasyEffects plugin for audio profile switching";
    homepage = "https://github.com/jonkristian/dms-easyeffects";
    license = lib.licenses.gpl3Only;
  };

  quickTotePlugin = mkPlugin {
    pname = "dms-quick-tote";
    src = arrozInputs.dms-quick-tote;
    description = "DankMaterialShell Quick Tote plugin for pinned files, downloads, and screenshots";
    homepage = "https://github.com/JDKamalakar/DMS-Quick_Tote";
    license = lib.licenses.mit;
  };

  clipboardPlusPlugin = mkPlugin {
    pname = "dms-clipboard-plus";
    src = arrozInputs.dms-clipboard-plus;
    subdir = "ClipboardPlus";
    description = "DankMaterialShell advanced clipboard manager plugin";
    homepage = "https://github.com/Dadangdut33/dms-plugins/tree/master/ClipboardPlus";
    license = lib.licenses.mit;
  };

  githubHeatmapPlugin = mkPlugin {
    pname = "dms-github-heatmap";
    src = arrozInputs.dms-github-heatmap;
    description = "DankMaterialShell GitHub contribution heatmap plugin";
    homepage = "https://github.com/JDKamalakar/DMS-GitHub_HeatMap";
    license = lib.licenses.mit;
  };

  amdGpuMonitorPlugin = mkPlugin {
    pname = "dms-amd-gpu-monitor";
    src = arrozInputs.dms-amd-gpu-monitor;
    description = "DankMaterialShell AMD GPU monitor plugin";
    homepage = "https://github.com/JDKamalakar/DMS-AMD_GPU_Monitor_Revive";
    license = lib.licenses.mit;
  };

  catWidgetPlugin = mkPlugin {
    pname = "dms-cat-widget";
    src = arrozInputs.dms-cat-widget;
    description = "DankMaterialShell animated CPU cat widget plugin";
    homepage = "https://github.com/xi-ve/cat-dms";
    license = lib.licenses.mit;
  };

  aiUsagePlugin = arrozInputs.dms-plugins.packages.${system}.aiUsage;

  ankerC200Plugin = arrozInputs.anker-c200.packages.${system}.ankerC200;
}
