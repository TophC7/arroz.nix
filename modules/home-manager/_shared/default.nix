# Shared Home Manager desktop modules
# Auto-discovers and imports all modules in this directory
{ lib, ... }:
{
  imports = lib.fs.scanPaths ./.;
}
