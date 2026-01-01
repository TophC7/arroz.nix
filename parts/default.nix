# Entry point for arroz.nix flake-parts modules
#
# The default flakeModule wraps mix-nix's hosts module with arroz's
# extended host spec (desktop/greeter options) and auto-injects
# arroz modules into coreModules/coreHomeModules.
#
# Usage:
#   imports = [ inputs.arroz-nix.flakeModules.default ];
#
_: {
  imports = [
    ./hosts.nix # Wraps mix-nix hosts + auto-injects arroz modules
  ];

  # Expose flake-parts modules for consumers
  flake.flakeModules = {
    default = ./default.nix;
    hosts = ./hosts.nix;
  };
}
