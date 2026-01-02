# Copyous GNOME extension dependencies
# Provides highlight.js for syntax highlighting in clipboard history
{ pkgs, lib, ... }:
let
  highlightJs = pkgs.fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/es/highlight.min.js";
    hash = "sha256-eGWDmUnwdk2eCiHjEaTixCYz7q7oyl7BJ7hkOFZXMf4=";
  };
in
{
  # Place highlight.js where copyous expects it
  xdg.dataFile."copyous@boerdereinar.dev/highlight.min.js".source = highlightJs;
}
