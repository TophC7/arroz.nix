# Entry point for arroz.nix flake-parts modules
#
# Extends mix-nix's host system with desktop/greeter options
# and auto-injects arroz NixOS/Home Manager modules.
#
# Usage:
#   imports = [
#     inputs.mix-nix.flakeModules.default  # Consumer must import mix-nix first
#     inputs.arroz-nix.flakeModules.default
#   ];
#
# NOTE: This module does NOT import mix-nix.flakeModules.hosts directly.
# Consumers must import mix-nix themselves.
#
{ arrozInputs }:
{
  imports = [
    (import ./hosts.nix { inherit arrozInputs; })
  ];
}
