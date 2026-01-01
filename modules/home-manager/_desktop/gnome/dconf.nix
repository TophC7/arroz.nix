# GNOME dconf settings
# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  lib,
  pkgs,
  inputs,
  ...
}:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/TextEditor" = lib.mkDefault {
      style-scheme = "stylix";
    };

    "org/gnome/desktop/input-sources" = lib.mkDefault {
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
      ];
      xkb-options = [
        "terminate:ctrl_alt_bksp"
        "lv3:ralt_switch"
        "compose:menu"
      ];
    };

    "org/gnome/desktop/wm/keybindings" = lib.mkDefault {
      ## Workspace switching ##
      switch-to-workspace-1 = [ ]; # Default: ['<Super>Home']
      switch-to-workspace-2 = [ ];
      switch-to-workspace-3 = [ ];
      switch-to-workspace-4 = [ ];
      switch-to-workspace-5 = [ ];
      switch-to-workspace-6 = [ ];
      switch-to-workspace-7 = [ ];
      switch-to-workspace-8 = [ ];
      switch-to-workspace-9 = [ ];
      switch-to-workspace-10 = [ ];
      switch-to-workspace-11 = [ ];
      switch-to-workspace-12 = [ ];
      switch-to-workspace-left = [ ]; # Default: ['<Super>Page_Up','<Super><Alt>Left','<Control><Alt>Left']
      switch-to-workspace-right = [ ]; # Default: ['<Super>Page_Down','<Super><Alt>Right','<Control><Alt>Right']
      switch-to-workspace-up = [ ]; # Default: ['<Control><Alt>Up']
      switch-to-workspace-down = [ ]; # Default: ['<Control><Alt>Down']
      switch-to-workspace-last = [ ]; # Default: ['<Super>End']

      ## Application/Window switching ##
      switch-group = [
        "<Super>Above_Tab"
        "<Alt>Above_Tab"
      ];
      switch-group-backward = [
        "<Shift><Super>Above_Tab"
        "<Shift><Alt>Above_Tab"
      ];
      switch-applications = [ ]; # Default: ['<Super>Tab','<Alt>Tab']
      switch-applications-backward = [
        "<Shift><Super>Tab"
        "<Shift><Alt>Tab"
      ];
      switch-windows = [ ];
      switch-windows-backward = [ ];
      switch-panels = [ "<Control><Alt>Tab" ];
      switch-panels-backward = [ "<Shift><Control><Alt>Tab" ];

      ## Direct cycling ##
      cycle-group = [ ]; # Default: ['<Alt>F6']
      cycle-group-backward = [ ]; # Default: ['<Shift><Alt>F6']
      cycle-windows = [ ]; # Default: ['<Alt>Escape']
      cycle-windows-backward = [ ]; # Default: ['<Shift><Alt>Escape']
      cycle-panels = [ ]; # Default: ['<Control><Alt>Escape']
      cycle-panels-backward = [ ]; # Default: ['<Shift><Control><Alt>Escape']

      ## Window management ##
      show-desktop = [ ];
      panel-main-menu = [ ]; # DEPRECATED
      panel-run-dialog = [ "<Alt>F2" ];
      set-spew-mark = [ ];
      activate-window-menu = [ ]; # Default: ['<Alt>space']
      toggle-fullscreen = [ ];
      toggle-maximized = [ ]; # Default: ['<Alt>F10']
      toggle-above = [ ];
      maximize = [ ]; # Default: ['<Super>Up']
      unmaximize = [ ]; # Default: ['<Super>Down','<Alt>F5']
      minimize = [ ]; # Default: ['<Super>h']
      close = [ ]; # Default: ['<Alt>F4']
      begin-move = [ ]; # Default: ['<Alt>F7']
      begin-resize = [ ]; # Default: ['<Alt>F8']
      toggle-on-all-workspaces = [ ];
      move-to-workspace-1 = [ ]; # Default: ['<Super><Shift>Home']
      move-to-workspace-2 = [ ];
      move-to-workspace-3 = [ ];
      move-to-workspace-4 = [ ];
      move-to-workspace-5 = [ ];
      move-to-workspace-6 = [ ];
      move-to-workspace-7 = [ ];
      move-to-workspace-8 = [ ];
      move-to-workspace-9 = [ ];
      move-to-workspace-10 = [ ];
      move-to-workspace-11 = [ ];
      move-to-workspace-12 = [ ];
      move-to-workspace-last = [ ]; # Default: ['<Super><Shift>End']
      move-to-workspace-left = [ ]; # Default: ['<Super><Shift>Page_Up','<Super><Shift><Alt>Left','<Control><Shift><Alt>Left']
      move-to-workspace-right = [ ]; # Default: ['<Super><Shift>Page_Down','<Super><Shift><Alt>Right','<Control><Shift><Alt>Right']
      move-to-workspace-up = [ ]; # Default: ['<Control><Shift><Alt>Up']
      move-to-workspace-down = [ ]; # Default: ['<Control><Shift><Alt>Down']
      move-to-monitor-left = [ ]; # Default: ['<Super><Shift>Left']
      move-to-monitor-right = [ ]; # Default: ['<Super><Shift>Right']
      move-to-monitor-up = [ ]; # Default: ['<Super><Shift>Up']
      move-to-monitor-down = [ ]; # Default: ['<Super><Shift>Down']
      raise-or-lower = [ ];
      raise = [ ];
      lower = [ ];
      maximize-vertically = [ ];
      maximize-horizontally = [ ];
      move-to-corner-nw = [ ];
      move-to-corner-ne = [ ];
      move-to-corner-sw = [ ];
      move-to-corner-se = [ ];
      move-to-side-n = [ ];
      move-to-side-s = [ ];
      move-to-side-e = [ ];
      move-to-side-w = [ ];
      move-to-center = [ ];
      always-on-top = [ ];

      ## Input switching ##
      switch-input-source = [ ]; # Default: ['<Super>space','XF86Keyboard']
      switch-input-source-backward = [ ]; # Default: ['<Shift><Super>space','<Shift>XF86Keyboard']
    };

    "org/gnome/desktop/wm/preferences" = lib.mkDefault {
      num-workspaces = 3;
    };

    "org/gnome/mutter" = {
      experimental-features = lib.mkDefault [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/settings-daemon/plugins/color" = lib.mkDefault {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 19.0;
      night-light-temperature = (mkUint32 3892);
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.mkDefault [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];

      ## Non-static ##:
      battery-status = lib.mkDefault [ ];
      calculator = lib.mkDefault [ ];
      control-center = lib.mkDefault [ ];
      decrease-text-size = lib.mkDefault [ ];
      eject = lib.mkDefault [ ];
      email = lib.mkDefault [ ];
      help = lib.mkDefault [ ]; # Default: ['', '<Super>F1']
      hibernate = lib.mkDefault [ ];
      home = lib.mkDefault [ ];
      increase-text-size = lib.mkDefault [ ];
      keyboard-brightness-down = lib.mkDefault [ ];
      keyboard-brightness-toggle = lib.mkDefault [ ];
      keyboard-brightness-up = lib.mkDefault [ ];
      logout = lib.mkDefault [ "<Control><Alt>Delete" ];
      magnifier = lib.mkDefault [ ]; # Default: ['<Alt><Super>8']
      magnifier-zoom-in = lib.mkDefault [ ]; # Default: ['<Alt><Super>equal']
      magnifier-zoom-out = lib.mkDefault [ ]; # Default: ['<Alt><Super>minus']
      media = lib.mkDefault [ ];
      mic-mute = lib.mkDefault [ ];
      next = lib.mkDefault [ "AudioNext" ];
      on-screen-keyboard = lib.mkDefault [ ];
      pause = lib.mkDefault [ ];
      play = lib.mkDefault [ "AudioPlay" ];
      playback-forward = lib.mkDefault [ ];
      playback-random = lib.mkDefault [ ];
      playback-repeat = lib.mkDefault [ ];
      playback-rewind = lib.mkDefault [ ];
      power = lib.mkDefault [ ];
      previous = lib.mkDefault [ "AudioPrev" ];
      reboot = lib.mkDefault [ "<Super>r" ];
      rfkill = lib.mkDefault [ ];
      rfkill-bluetooth = lib.mkDefault [ ];
      rotate-video-lock = lib.mkDefault [ ];
      screen-brightness-cycle = lib.mkDefault [ ];
      screen-brightness-down = lib.mkDefault [ ];
      screen-brightness-up = lib.mkDefault [ ];
      screenreader = lib.mkDefault [ ];
      screensaver = lib.mkDefault [ ]; # Default: ['<Super>l']
      search = lib.mkDefault [ ];
      shutdown = lib.mkDefault [ "<Super>x" ];
      stop = lib.mkDefault [ ];
      suspend = lib.mkDefault [ ];
      toggle-contrast = lib.mkDefault [ ];
      touchpad-off = lib.mkDefault [ ];
      touchpad-on = lib.mkDefault [ ];
      touchpad-toggle = lib.mkDefault [ ];
      volume-down = lib.mkDefault [ "AudioLowerVolume" ];
      volume-down-precise = lib.mkDefault [ ];
      volume-down-quiet = lib.mkDefault [ ];
      volume-mute = lib.mkDefault [ "AudioMute" ];
      volume-mute-quiet = lib.mkDefault [ ];
      volume-step = lib.mkDefault 5; # Default: 6
      volume-up = lib.mkDefault [ "AudioRaiseVolume" ];
      volume-up-precise = lib.mkDefault [ ];
      volume-up-quiet = lib.mkDefault [ ];
      www = lib.mkDefault [ "<Super>w" ];

      ## Static keys ##
      battery-status-static = lib.mkDefault [ ];
      calculator-static = lib.mkDefault [ ];
      control-center-static = lib.mkDefault [ ];
      eject-static = lib.mkDefault [ ];
      email-static = lib.mkDefault [ ];
      hibernate-static = lib.mkDefault [ ];
      home-static = lib.mkDefault [ "<Super>f" ];
      keyboard-brightness-down-static = lib.mkDefault [ ];
      keyboard-brightness-toggle-static = lib.mkDefault [ ];
      keyboard-brightness-up-static = lib.mkDefault [ ];
      media-static = lib.mkDefault [ ];
      mic-mute-static = lib.mkDefault [ ];
      next-static = lib.mkDefault [ ];
      pause-static = lib.mkDefault [ ];
      play-static = lib.mkDefault [ ];
      playback-forward-static = lib.mkDefault [ ];
      playback-random-static = lib.mkDefault [ ];
      playback-repeat-static = lib.mkDefault [ ];
      playback-rewind-static = lib.mkDefault [ ];
      power-static = lib.mkDefault [ ];
      previous-static = lib.mkDefault [ ];
      rfkill-bluetooth-static = lib.mkDefault [ ];
      rfkill-static = lib.mkDefault [ ];
      rotate-video-lock-static = lib.mkDefault [ ];
      screen-brightness-cycle-static = lib.mkDefault [ ];
      screen-brightness-down-static = lib.mkDefault [ "XF86MonBrightnessDown" ];
      screen-brightness-up-static = lib.mkDefault [ "XF86MonBrightnessUp" ];
      screensaver-static = lib.mkDefault [ ];
      search-static = lib.mkDefault [ ];
      stop-static = lib.mkDefault [ ];
      suspend-static = lib.mkDefault [ ];
      touchpad-off-static = lib.mkDefault [ ];
      touchpad-on-static = lib.mkDefault [ ];
      touchpad-toggle-static = lib.mkDefault [ ];
      volume-down-precise-static = lib.mkDefault [ ];
      volume-down-quiet-static = lib.mkDefault [ ];
      volume-down-static = lib.mkDefault [ ];
      volume-mute-quiet-static = lib.mkDefault [ ];
      volume-mute-static = lib.mkDefault [ ];
      volume-up-precise-static = lib.mkDefault [ ];
      volume-up-quiet-static = lib.mkDefault [ ];
      volume-up-static = lib.mkDefault [ ];
      www-static = lib.mkDefault [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = lib.mkDefault {
      binding = "<Super>t";
      command = "ghostty";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = lib.mkDefault {
      binding = "<Super>e";
      command = "code";
      name = "Code";
    };

    "org/gnome/shell" = {
      disable-user-extensions = lib.mkForce false;
      enabled-extensions = lib.mkDefault [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "auto-accent-colour@Wartybix"
        "blur-my-shell@aunetx"
        "color-picker@tuberry"
        "dash-in-panel@fthx"
        "flickernaut@imoize.github.io"
        "just-perfection-desktop@just-perfection"
        "monitor-brightness-volume@ailin.nemui"
        "pano@elhan.io"
        "paperwm@paperwm.github.com"
        "quicksettings-audio-devices-hider@marcinjahn.com"
        "quicksettings-audio-devices-renamer@marcinjahn.com"
        "solaar-extension@sidevesh"
        "undecorate@sun.wxg@gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps =
        let
          zen-browser =
            inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta.meta.desktopFileName or "zen-browser.desktop";
        in
        lib.mkDefault [
          "com.mitchellh.ghostty.desktop"
          "org.gnome.Nautilus.desktop"
          zen-browser
          "code.desktop"
        ];
      last-selected-power-profile = lib.mkDefault "performance";
    };

    "org/gnome/shell/extensions/alphabetical-app-grid" = lib.mkDefault {
      folder-order-position = "start";
    };

    "org/gnome/shell/extensions/appindicator" = lib.mkDefault {
      icon-brightness = 0.0;
      icon-contrast = 0.0;
      icon-opacity = 240;
      icon-saturation = 0.0;
      icon-size = 0;
      legacy-tray-enabled = true;
      tray-pos = "right";
    };

    "org/gnome/shell/extensions/auto-accent-colour" = lib.mkDefault {
      disable-cache = false;
      hide-indicator = true;
      highlight-mode = true;
    };

    "org/gnome/shell/extensions/blur-my-shell" = lib.mkDefault {
      hacks-level = 1;
      settings-version = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = lib.mkDefault {
      brightness = 1.0;
      sigma = 85;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = lib.mkDefault {
      blacklist = [
        "Plank"
        "com.desktop.ding"
        "Conky"
        ".gamescope-wrapped"
        "steam_app_*"
        "steam_app_2694490"
        "Ryubing"
      ];
      blur = true;
      dynamic-opacity = false;
      enable-all = true;
      opacity = 230;
      sigma = 85;
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = lib.mkDefault {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = lib.mkDefault {
      blur = false;
      brightness = 1.0;
      override-background = true;
      pipeline = "pipeline_default_rounded";
      sigma = 85;
      static-blur = false;
      style-dash-to-dock = 0;
      unblur-in-overview = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = lib.mkDefault {
      blur-original-panel = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = lib.mkDefault {
      compatibility = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = lib.mkDefault {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = lib.mkDefault {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = lib.mkDefault {
      brightness = 1.0;
      override-background = true;
      pipeline = "pipeline_default";
      sigma = 85;
      static-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = lib.mkDefault {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/color-picker" = lib.mkDefault {
      auto-copy = true;
      color-picker-shortcut = [ "<Control><Super>c" ];
      enable-format = true;
      enable-notify = false;
      enable-shortcut = true;
      enable-sound = false;
      notify-sound = mkUint32 1;
      notify-style = mkUint32 0;
    };

    "org/gnome/shell/extensions/dash-in-panel" = lib.mkDefault {
      button-margin = 6;
      center-dash = true;
      colored-dot = true;
      icon-size = 32;
      move-date = true;
      panel-height = 46;
      show-apps = false;
      show-dash = false;
      show-label = true;
    };

    "org/gnome/shell/extensions/just-perfection" = lib.mkDefault {
      accessibility-menu = true;
      activities-button = false;
      clock-menu = true;
      clock-menu-position = 1;
      dash = true;
      dash-app-running = true;
      dash-separator = false;
      keyboard-layout = true;
      max-displayed-search-results = 0;
      panel-in-overview = true;
      quick-settings = true;
      quick-settings-dark-mode = true;
      ripple-box = true;
      show-apps-button = false;
      support-notifier-showed-version = 34;
      support-notifier-type = 0;
      top-panel-position = 0;
      window-preview-close-button = true;
      workspace = false;
      workspace-switcher-size = 0;
      workspaces-in-app-grid = true;
    };

    "org/gnome/shell/extensions/pano" = lib.mkDefault {
      global-shortcut = [ "<Super>v" ];
      history-length = 500;
      incognito-shortcut = [ "<Shift><Super>v" ];
      is-in-incognito = false;
      window-position = mkUint32 2;
    };

    "org/gnome/shell/extensions/paperwm" = lib.mkDefault {
      cycle-height-steps = [
        0.25
        0.35
        0.5
        0.65
        0.95
        1.0
      ];
      cycle-width-steps = [
        0.25
        0.35
        0.5
        0.65
        0.95
        1.0
      ];
      default-focus-mode = 1;
      disable-topbar-styling = true;
      edge-preview-enable = true;
      edge-preview-timeout-enable = false;
      gesture-enabled = true;
      gesture-horizontal-fingers = 3;
      gesture-workspace-fingers = 4;
      horizontal-margin = 8;
      last-used-display-server = "Wayland";
      restore-attach-modal-dialogs = "true";
      restore-edge-tiling = "true";
      restore-workspaces-only-on-primary = "true";
      selection-border-size = 4;
      show-focus-mode-icon = false;
      show-open-position-icon = false;
      show-window-position-bar = false;
      show-workspace-indicator = false;
      vertical-margin = 8;
      vertical-margin-bottom = 8;
      window-gap = 8;
      winprops = [
        ''{"wm_class":"Code","spaceIndex":0}''
        ''{"wm_class":"com.jaoushingan.WaydroidHelper","scratch_layer":true}''
        ''{"wm_class":"com.mitchellh.ghostty","scratch_layer":true}''
        ''{"wm_class":"discord","preferredWidth":"100%","spaceIndex":1}''
        ''{"wm_class":"gnome-control-center","scratch_layer":true}''
        ''{"wm_class":"gnome-extensions-app","scratch_layer":true}''
        ''{"wm_class":"org.gnome.Extensions","scratch_layer":true}''
        ''{"wm_class":"org.gnome.Nautilus","scratch_layer":true}''
        ''{"wm_class":"TelegramDesktop","spaceIndex":1}''
        ''{"wm_class":"Waydroid","preferredWidth":"100%","spaceIndex":0,"title":""}''
        ''{"wm_class":".gamescope-wrapped","preferredWidth":"100%","spaceIndex":2}''
      ];
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = lib.mkDefault {
      center = [ "<Super>c" ];
      center-horizontally = [ ];
      center-vertically = [ ];
      close-window = [ "<Super>q" ];
      cycle-height = [ "<Alt><Super>Up" ];
      cycle-height-backwards = [ "<Alt><Super>Down" ];
      cycle-width = [ "<Alt><Super>Right" ];
      cycle-width-backwards = [ "<Alt><Super>Left" ];
      live-alt-tab = [ "<Alt>Tab" ];
      live-alt-tab-backward = [ ];
      live-alt-tab-scratch = [ ];
      live-alt-tab-scratch-backward = [ ];
      move-down = [ "<Shift><Super>Down" ];
      move-down-workspace = [ "<Control><Super>Down" ];
      move-left = [ "<Shift><Super>Left" ];
      move-monitor-above = [ ];
      move-monitor-below = [ ];
      move-monitor-left = [ "<Control><Super>Left" ];
      move-monitor-right = [ "<Control><Super>Right" ];
      move-previous-workspace = [ ];
      move-previous-workspace-backward = [ ];
      move-right = [ "<Shift><Super>Right" ];
      move-space-monitor-above = [ ];
      move-space-monitor-below = [ ];
      move-space-monitor-left = [ ];
      move-space-monitor-right = [ ];
      move-up = [ "<Shift><Super>Up" ];
      move-up-workspace = [ "<Control><Super>Up" ];
      new-window = [ "<Super>n" ];
      previous-workspace = [ ];
      previous-workspace-backward = [ ];
      swap-monitor-above = [ ];
      swap-monitor-below = [ ];
      swap-monitor-left = [ ];
      swap-monitor-right = [ ];
      switch-down-workspace = [ "<Super>Page_Down" ];
      switch-focus-mode = [ "<Alt><Super>a" ];
      switch-monitor-above = [ ];
      switch-monitor-below = [ ];
      switch-monitor-left = [ ];
      switch-monitor-right = [ ];
      switch-next = [ ];
      switch-open-window-position = [ ];
      switch-previous = [ ];
      switch-up-workspace = [ "<Super>Page_Up" ];
      take-window = [ ];
      toggle-maximize-width = [ ];
      toggle-scratch = [ "<Super>BackSpace" ];
      toggle-scratch-layer = [ "<Control><Super>BackSpace" ];
      toggle-scratch-window = [ ];
      toggle-top-and-position-bar = [ ];
    };

    "org/gnome/shell/extensions/user-theme" = lib.mkDefault {
      name = "Stylix";
    };

    "org/gnome/shell/extensions/vitals" = lib.mkDefault {
      alphabetize = true;
      fixed-widths = true;
      hide-icons = false;
      hide-zeros = true;
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "_gpu#1_usage_"
        "__temperature_avg__"
        "_network_lo_"
        "_storage_free_"
      ];
      icon-style = 1;
      include-static-gpu-info = true;
      include-static-info = true;
      menu-centered = false;
      position-in-panel = 0;
      show-fan = false;
      show-gpu = true;
      show-memory = true;
      show-network = true;
      show-processor = true;
      show-storage = true;
      show-system = true;
      show-temperature = true;
      show-voltage = false;
      use-higher-precision = false;
    };

    "org/gnome/shell/keybindings" = lib.mkDefault {
      focus-active-notification = [ ];
      screenshot = [ "Print" ];
      screenshot-window = [ ];
      shift-overview-down = [ ];
      shift-overview-up = [ ];
      show-screen-recording-ui = [ ];
      show-screenshot-ui = [ "<Shift>Print" ];
      toggle-application-view = [ "Home" ];
      toggle-message-tray = [ "<Super>s" ];
      toggle-quick-settings = [ "<Super>a" ];
    };

    "org/virt-manager/virt-manager/connections" = lib.mkDefault {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
