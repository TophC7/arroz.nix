{
  description = "arroz.nix - Reusable desktop rice configurations for NixOS";

  inputs = {
    # Derive nixpkgs from mix-nix for cache coherence
    # This ensures mix.nix packages use cached builds
    nixpkgs.follows = "mix-nix/nixpkgs";

    ## NixOS ##

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Core dependency for lib.fs.*, theme, monitors
    mix-nix = {
      # url = "github:tophc7/mix.nix";
      url = "git+file:///repo/Nix/mix.nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Theming ##

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Dank Material Shell ##

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-actions = {
      url = "github:AvengeMedia/dms-plugins";
      flake = false;
    };

    dms-easyeffects = {
      url = "github:jonkristian/dms-easyeffects";
      flake = false;
    };

    dms-display-settings = {
      url = "github:Lucyfire/dms-plugins";
      flake = false;
    };

    dms-nix-monitor = {
      url = "github:antonjah/nix-monitor";
      flake = false;
    };

    ## Niri Ecosystem ##

    niri = {
      url = "github:tophc7/niri-flake";
      # url = "git+file:///repo/Nix/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Hyprland Ecosystem ##

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    hyprnavi-psm = {
      # url = "github:TophC7/hyprnavi-psm";
      url = "git+file:///repo/rust/hyprnavi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ambxst = {
      url = "github:Axenide/Ambxst";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        quickshell.follows = "quickshell";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      # Reuse mix.nix extended lib (provides lib.fs.*, lib.hosts.*, etc.)
      lib = inputs.mix-nix.lib;
    in
    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = { inherit lib; };
      }
      {

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        # Expose extended lib as flake output
        flake.lib = lib;
      }
    # Direct flake outputs - bypass flake-parts to avoid conflicts with mix.nix
    # Capture arroz's inputs in closures so they're available when imported by consumers
    // {
      flakeModules = {
        default = import ./parts/default.nix { arrozInputs = inputs; };
        hosts = import ./parts/hosts.nix { arrozInputs = inputs; };
      };
    };
}
