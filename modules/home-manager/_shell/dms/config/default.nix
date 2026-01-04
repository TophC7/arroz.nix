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
        chmod 755 ${cfgDir}/clsettings.json
      '';
    };

    ".config/DankMaterialShell/settings_source.json" = {
      source = ./settings.json;
      onChange = ''
        cp ${cfgDir}/settings_source.json ${cfgDir}/settings.json
        chmod 755 ${cfgDir}/settings.json
      '';
    };
  };
}
