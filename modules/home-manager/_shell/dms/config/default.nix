{ config, ... }:
let
  cfgDir = "${config.xdg.configHome}/DankMaterialShell";
in
{
  home.file = {
    ## DankMaterialShell config files ##
    ".config/DankMaterialShell/clsettings_source.json" = {
      source = ./clsettings.json;
      onChange = ''
        cp ${cfgDir}/clsettings_source.json ${cfgDir}/clsettings.json
        chmod 644 ${cfgDir}/clsettings.json
      '';
    };

    ".config/DankMaterialShell/default-settings_source.json" = {
      source = ./default-settings.json;
      onChange = ''
        cp ${cfgDir}/default-settings_source.json ${cfgDir}/default-settings.json
        chmod 644 ${cfgDir}/default-settings.json
      '';
    };
  };
}
