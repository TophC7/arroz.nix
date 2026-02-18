# Shared Hyprland monitor configuration helpers
# Underscore prefix excludes this from lib.fs.scanPaths auto-discovery
{ lib, config }:
let
  monitors = config.monitors or [ ];

  formatMonitor =
    m:
    let
      resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
      position = "${toString m.x}x${toString m.y}";
      scale = toString m.scale;
      transform = toString m.transform;
      vrr = if (m.vrr or false) != false then ",vrr,1" else "";
    in
    "${m.name},${
      if m.enabled then "${resolution},${position},${scale},transform,${transform}${vrr}" else "disable"
    }";

  # List of monitor strings for hyprland settings.monitor
  # Falls back to auto-detection if no monitors are defined
  monitorList =
    if monitors == [ ] then
      [ ",preferred,auto,1" ]
    else
      lib.forEach monitors formatMonitor;

  # Newline-joined monitor lines with "monitor = " prefix for plain text config
  # Falls back to auto-detection if no monitors are defined
  monitorLines =
    if monitors == [ ] then
      "monitor = , preferred, auto, auto"
    else
      lib.concatStringsSep "\n" (lib.forEach monitors (m: "monitor = ${formatMonitor m}"));
in
{
  inherit formatMonitor monitorList monitorLines;
}
