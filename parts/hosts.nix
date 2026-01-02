# arroz.nix hosts flake-parts module
#
# Extends mix.nix with desktop/greeter options and auto-injects arroz modules.
# Uses mix.hostSpecExtensions for composable type extension.
#
# External flake inputs (niri, hyprland, etc.) are:
# - NixOS/HM modules: imported directly here
# - Packages: accessed via arrozInputs (passed to modules via _module.args)
#
# This file is a function that receives arrozInputs (arroz.nix's flake inputs)
# and returns a flake-parts module. This allows arroz's inputs to be captured
# in the closure, making them available even when imported by consumer flakes.
#
# Usage:
#   imports = [
#     inputs.mix-nix.flakeModules.default
#     inputs.arroz-nix.flakeModules.default
#   ];
#
#   mix.hosts.myhost = {
#     user = "toph";
#     desktop.hyprland.enable = true;
#     greeter.type = "dms";
#   };
#
{ arrozInputs }:
{
  config.mix = {
    hostSpecExtensions = [ ../lib/hostSpec.nix ];

    # specialArgs available before module evaluation (no infinite recursion)
    specialArgs = { inherit arrozInputs; };

    coreModules = [ ../modules/nixos ];
    coreHomeModules = [ ../modules/home-manager ];
  };
}
