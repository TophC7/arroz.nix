# arroz.nix hosts flake-parts module
#
# Wraps mix.nix's hosts module with arroz's extended host spec
# and auto-injects arroz modules into coreModules/coreHomeModules.
#
# Usage:
#   imports = [ inputs.arroz-nix.flakeModules.default ];
#
#   mix.hosts.myhost = {
#     user = "toph";
#     desktop.hyprland.enable = true;
#     greeter.type = "dms";
#   };
#
{ inputs, lib, ... }:

let
  # Extended host spec with desktop/greeter options
  arrozHostSpec = import ../lib/hostSpec.nix { inherit lib; };
in
{
  imports = [
    # Wrap mix-nix hosts module with our extended spec type
    # Import the path first to get the factory function, then call it
    ((import inputs.mix-nix.flakeModules.hosts) {
      hostSpecType = arrozHostSpec;
    })
  ];

  # Auto-inject arroz modules into coreModules/coreHomeModules
  # Consumers don't need to manually import modules - they load automatically
  # The modules use host.desktop.* and host.greeter.* to conditionally enable features
  config.mix = {
    coreModules = [
      ../modules/nixos # NixOS desktop/greeter modules
    ];
    coreHomeModules = [
      ../modules/home-manager # Home Manager desktop/greeter modules
    ];
  };
}
