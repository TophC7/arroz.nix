# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**arroz.nix** is a desktop environment extension for [mix.nix](https://github.com/TophC7/mix.nix). It extends mix.nix's host spec with desktop and greeter options, providing pre-configured modules for GNOME, Hyprland, and Niri that are conditionally loaded based on host configuration.

This is a **library flake** - it's consumed by other flakes via `inputs.arroz-nix.flakeModules.default`.

## Common Development Commands

```bash
# Check flake validity
nix flake check

# Test in a consumer flake (gojo.nix is the test consumer)
cd ../gojo.nix && nix flake check --no-build

# Show flake outputs
nix flake show
```

## Architecture

### Input Forwarding Pattern

arroz.nix bundles desktop-related inputs (niri, hyprland, stylix, etc.) so consumers don't need to manage them. The key pattern is **arrozInputs forwarding**:

```nix
# flake.nix - Capture inputs in closure
flakeModules.default = import ./parts/default.nix { arrozInputs = inputs; };

# parts/hosts.nix - Pass to modules via specialArgs
{ arrozInputs }:
{
  config.mix.specialArgs = { inherit arrozInputs; };
}

# modules/nixos/_desktop/niri/default.nix - Use arrozInputs
{ arrozInputs, pkgs, ... }:
{
  imports = [ arrozInputs.niri.nixosModules.niri ];
  nixpkgs.overlays = [ arrozInputs.niri.overlays.niri ];
}
```

**Why specialArgs?** Using `_module.args` causes infinite recursion when args are used in `imports` (imports evaluate before config). `specialArgs` is provided before module evaluation.

### Conditional Module Loading

Modules are conditionally imported based on `host.desktop.*` and `host.greeter.*`:

```nix
# modules/nixos/default.nix
imports = lib.flatten [
  (lib.optional (desktop.gnome.enable or false) ./_desktop/gnome)
  (lib.optional (desktop.hyprland.enable or false) ./_desktop/hyprland)
  (lib.optional (desktop.niri.enable or false) ./_desktop/niri)
  (lib.optional (greeter.type or null == "dms") ./_greeter/dms.nix)
  (lib.optional hasDesktop ./_shared)
];
```

### Directory Structure Convention

- `_` prefix excludes from `lib.fs.scanPaths` auto-discovery
- Directories starting with `_` are conditionally imported manually
- This enables selective loading based on host spec

```
modules/
├── nixos/
│   ├── default.nix          # Entry point - conditional imports
│   ├── _desktop/             # Desktop-specific (conditional)
│   │   ├── _wayland.nix      # Shared Wayland config
│   │   ├── gnome/
│   │   ├── hyprland/
│   │   └── niri/
│   ├── _greeter/             # Greeter-specific (conditional)
│   └── _shared/              # Loaded when any desktop enabled
└── home-manager/
    └── (same pattern)
```

### Host Spec Extension

arroz.nix extends mix.nix's host spec via `mix.hostSpecExtensions`:

```nix
# lib/hostSpec.nix adds:
options.desktop.{gnome,hyprland,niri}.enable
options.desktop.{gnome,hyprland,niri}.default  # Primary session
options.greeter.type      # "gdm" | "dms" | "tuigreet" | null
options.greeter.autoLogin
```

## Development Guidelines

### When Adding a New Desktop Environment

1. Create `modules/nixos/_desktop/<name>/default.nix`
2. Create `modules/home-manager/_desktop/<name>/default.nix`
3. Add option to `lib/hostSpec.nix`
4. Add conditional import in both `modules/nixos/default.nix` and `modules/home-manager/default.nix`
5. If Wayland-based, import `../_wayland.nix` for shared config

### When Adding a New Greeter

1. Create `modules/nixos/_greeter/<name>.nix`
2. Optionally create `modules/home-manager/_greeter/<name>/` if HM config needed
3. Add to greeter type enum in `lib/hostSpec.nix`
4. Add conditional import in module entry points

### Code Patterns

**Use `lib.mkDefault` for all settings** - allows consumers to override:
```nix
programs.niri.enable = lib.mkDefault true;
```

**Access external packages via arrozInputs**:
```nix
{ arrozInputs, pkgs, ... }:
let system = pkgs.stdenv.hostPlatform.system; in
{
  programs.hyprland.package = arrozInputs.hyprland.packages.${system}.hyprland;
}
```

**Shared Wayland config** - both Hyprland and Niri import `_wayland.nix` for common infrastructure (PipeWire, XDG portals, fonts, etc.)