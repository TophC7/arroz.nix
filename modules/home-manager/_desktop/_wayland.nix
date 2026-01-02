{ lib, ... }:

{
  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = lib.mkDefault "1"; # Java apps
    ELECTRON_OZONE_PLATFORM_HINT = lib.mkDefault "wayland"; # Electron apps
    MOZ_ENABLE_WAYLAND = lib.mkDefault "1"; # Firefox
    NIXOS_OZONE_WL = lib.mkDefault "1"; # Electron apps on Wayland
    QT_QPA_PLATFORM = lib.mkDefault "wayland"; # Qt apps
    SDL_VIDEODRIVER = lib.mkDefault "wayland"; # SDL apps
    XDG_SESSION_TYPE = lib.mkDefault "wayland";
  };
}
