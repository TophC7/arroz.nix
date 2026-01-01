# Entry point for arroz.nix flake-parts modules
#
# Wraps mix-nix's hosts module with arroz's extended host spec
# (desktop/greeter options) and auto-injects arroz modules.
#
# Usage:
#   imports = [ inputs.arroz-nix.flakeModules.default ];
#
{ arrozInputs }:
{
  imports = [
    arrozInputs.mix-nix.flakeModules.hosts
    (import ./hosts.nix { inherit arrozInputs; })
  ];
}
