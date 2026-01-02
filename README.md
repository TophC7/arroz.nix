<h1>
  <picture>
    <source srcset="https://fonts.gstatic.com/s/e/notoemoji/latest/2744_fe0f/512.webp" type="image/webp">
    <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/2744_fe0f/512.gif" alt="❄" width="32" height="32">
  </picture>
  arroz.nix (WIP)
</h1>

> **Desktop environment extension for [mix.nix](https://github.com/TophC7/mix.nix)**

---

## Overview

**arroz.nix** extends mix.nix's host spec with desktop and greeter options. Modules are conditionally loaded based on your host configuration; enable what you need.

**Supported Desktops:**
- GNOME
- Hyprland (w/  hyprscrolling, DankMaterialShell)
- Niri (w/ DankMaterialShell)

**Supported Greeters:**
- GDM
- DMS (DankMaterialShell greeter)
- tuigreet (TUI greeter via greetd)

---

## Installation

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    mix-nix.url = "github:tophc7/mix.nix";
    arroz-nix.url = "github:tophc7/arroz.nix";
  };

  outputs = inputs@{ flake-parts, mix-nix, arroz-nix, ... }:
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = { lib = mix-nix.lib; };
    } {
      imports = [ arroz-nix.flakeModules.default ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      mix = {
        # ... your mix.nix config (users, hostsDir, etc.)

        hosts.desktop = {
          user = "myuser";
          desktop.niri.enable = true;
          greeter.type = "dms";
        };
      };
    };
}
```

> **Note:** `arroz-nix.flakeModules.default` includes `mix-nix.flakeModules.hosts`, so you don't need to import both.

---

## Host Options

Options added to `mix.hosts.<name>`:

```nix
mix.hosts.myhost = {
  # Desktop environments (can enable multiple, mark one as default)
  desktop.gnome.enable = true;
  desktop.gnome.default = true;    # Primary session

  desktop.hyprland.enable = true;
  desktop.hyprland.default = false;

  desktop.niri.enable = true;
  desktop.niri.default = false;

  # Greeter
  greeter.type = "dms";       # "gdm" | "dms" | "tuigreet" | null
  greeter.autoLogin = false;  # Auto-login for primary user
};
```

## License

MIT
