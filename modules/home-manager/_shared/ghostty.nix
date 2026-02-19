# Ghostty terminal emulator configuration
# Replaces the default terminal emulator; gnome-terminal/gnome-console is disabled
{ lib, ... }:
{
  programs.ghostty = {
    enable = lib.mkDefault true;
    enableFishIntegration = lib.mkDefault true;
    settings = {
      theme = lib.mkDefault "dank16";
      font-family = lib.mkDefault "monospace";
      font-size = lib.mkDefault "11";
      background-opacity = lib.mkDefault "0.85";
      keybind = lib.mkDefault ''shift+enter=text:\x1b\r'';
      window-height = lib.mkDefault 45;
      window-width = lib.mkDefault 145;
      window-inherit-working-directory = lib.mkDefault true;
    };
  };

  home.sessionVariables = {
    TERM = lib.mkDefault "ghostty";
  };
}
