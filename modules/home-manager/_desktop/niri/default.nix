# Niri Home Manager Configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    (lib.fs.scanPaths ./.)
    ../_wayland.nix
  ];

  # Matugen template for Niri colors (skipped when DMS manages colors)
  theme.matugen.templates.niri-colors = lib.mkIf (!config.arroz.niri.dms.includeColors) {
    template = pkgs.writeText "niri-colors-template.kdl" ''
      layout {
          background-color "transparent"

          focus-ring {
              active-color   "{{colors.primary.default.hex}}"
              inactive-color "{{colors.outline.default.hex}}"
              urgent-color   "{{colors.error.default.hex}}"
          }

          border {
              active-color   "{{colors.primary.default.hex}}"
              inactive-color "{{colors.outline.default.hex}}"
              urgent-color   "{{colors.error.default.hex}}"
          }

          shadow {
              color "{{colors.shadow.default.hex}}70"
          }

          tab-indicator {
              active-color   "{{colors.primary.default.hex}}"
              inactive-color "{{colors.outline.default.hex}}"
              urgent-color   "{{colors.error.default.hex}}"
          }

          insert-hint {
              color "{{colors.primary.default.hex}}80"
          }
      }
    '';
    path = ".config/niri/arroz/colors.kdl";
  };

  # Arroz recent-windows config (skipped when DMS manages recents)
  xdg.configFile."niri/arroz/recents.kdl" = lib.mkIf (!config.arroz.niri.dms.includeRecents) {
    text = ''
      // Arroz recent-windows configuration
      recent-windows {
          debounce-ms 0
          open-delay-ms 0

          highlight {
              corner-radius 12
          }
      }
    '';
  };

  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = lib.mkDefault "us";
            options = lib.mkDefault "terminate:ctrl_alt_bksp,lv3:ralt_switch,compose:menu";
          };
        };

        touchpad = {
          tap = lib.mkDefault true;
          natural-scroll = lib.mkDefault true;
          dwt = lib.mkDefault true; # Disable while typing
        };

        mouse = {
          natural-scroll = lib.mkDefault false;
        };
      };

      # Prefer no server-side decorations
      prefer-no-csd = lib.mkDefault true;

      xwayland-satellite = {
        enable = lib.mkDefault true;
        path = lib.mkDefault (lib.getExe pkgs.xwayland-satellite);
      };

      # Layout settings (skipped when DMS manages layout)
      layout = lib.mkIf (!config.arroz.niri.dms.includeLayout) {
        gaps = lib.mkDefault 8;
        center-focused-column = lib.mkDefault "never";

        preset-column-widths = lib.mkDefault [
          { proportion = 0.25; }
          { proportion = 0.35; }
          { proportion = 0.5; }
          { proportion = 0.65; }
          { proportion = 0.90; }
          { proportion = 1.0; }
        ];

        default-column-width = lib.mkDefault {
          proportion = 0.5;
        };

        border = {
          enable = lib.mkDefault false;
          width = lib.mkDefault 4;
        };

        focus-ring = {
          enable = lib.mkDefault true;
          width = lib.mkDefault 4;
        };

        tab-indicator = {
          enable = lib.mkDefault true;
          position = lib.mkDefault "left"; # Show on left edge of windows
          width = lib.mkDefault 4;
          gap = lib.mkDefault 8;
          hide-when-single-tab = lib.mkDefault true;
          place-within-column = lib.mkDefault true;
        };
      };

      animations = {
        enable = lib.mkDefault true;
        slowdown = lib.mkDefault 1.0;

        window-open = {
          enable = lib.mkDefault true;
          kind = {
            easing = {
              curve = lib.mkDefault "ease-out-quad";
              duration-ms = lib.mkDefault 150;
            };
          };
        };

        window-close = {
          enable = lib.mkDefault true;
          kind = {
            easing = {
              curve = lib.mkDefault "ease-out-quad";
              duration-ms = lib.mkDefault 150;
            };
          };
        };

        window-movement = {
          enable = lib.mkDefault true;
          kind = {
            spring = {
              damping-ratio = lib.mkDefault 1.0;
              stiffness = lib.mkDefault 800;
              epsilon = lib.mkDefault 0.0001;
            };
          };
        };

        workspace-switch = {
          enable = lib.mkDefault true;
          kind = {
            spring = {
              damping-ratio = lib.mkDefault 1.0;
              stiffness = lib.mkDefault 1000;
              epsilon = lib.mkDefault 0.0001;
            };
          };
        };
      };

      # Screenshot configuration
      screenshot-path = lib.mkDefault "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # Outputs - dynamically configured from monitors option
      # Skipped when: DMS manages outputs OR monitors is empty/undefined
      outputs =
        let
          monitors = config.monitors or [ ];
          hasMonitors = monitors != [ ];
          dmsManagesOutputs = config.arroz.niri.dms.includeOutputs;

          # Convert transform number to Niri rotation (integer degrees)
          # 0 = normal, 1 = 90° CCW, 2 = 180°, 3 = 270° CCW
          transformToRotation =
            t:
            if t == 0 then
              0
            else if t == 1 then
              90
            else if t == 2 then
              180
            else if t == 3 then
              270
            else
              0;
        in
        lib.mkIf (hasMonitors && !dmsManagesOutputs) (
          lib.listToAttrs (
            lib.forEach monitors (
              monitor:
              lib.nameValuePair monitor.name {
                enable = monitor.enabled;
                mode = {
                  width = monitor.width;
                  height = monitor.height;
                  refresh = monitor.refreshRate + 0.0;
                };
                position = {
                  x = monitor.x;
                  y = monitor.y;
                };
                scale = monitor.scale;
                transform.rotation = transformToRotation monitor.transform;
                variable-refresh-rate = monitor.vrr or false;
              }
            )
          )
        );
    };
  };

  xdg.configFile = {
    niri-config-dms.enable = lib.mkForce false;
    niri-config = lib.mkForce {
      enable = true;
      target = "niri/config.kdl";
      text =
        let
          # Colors: arroz/colors.kdl or dms/colors.kdl
          colorsInclude =
            if config.arroz.niri.dms.includeColors then
              ''include "dms/colors.kdl"''
            else
              ''include "arroz/colors.kdl"'';

          # Recents: arroz/recents.kdl or dms/alttab.kdl
          recentsInclude =
            if config.arroz.niri.dms.includeRecents then
              ''include "dms/alttab.kdl"''
            else
              ''include "arroz/recents.kdl"'';

          # DMS-only includes (only when enabled)
          layoutInclude = lib.optionalString config.arroz.niri.dms.includeLayout ''include "dms/layout.kdl"'';
          bindsInclude = lib.optionalString config.arroz.niri.dms.includeBinds ''include "dms/binds.kdl"'';
          outputsInclude = lib.optionalString config.arroz.niri.dms.includeOutputs ''include "dms/outputs.kdl"'';
          wpblurInclude = lib.optionalString config.arroz.niri.dms.includeWpblur ''include "dms/wpblur.kdl"'';
        in
        ''
          ${config.programs.niri.finalConfig}

          ${bindsInclude}
          ${colorsInclude}
          ${layoutInclude}
          ${outputsInclude}
          ${recentsInclude}
          ${wpblurInclude}
        '';
    };
  };
}
