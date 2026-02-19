# Dank16 terminal theme generation
#
# Generates Ghostty and fish theme files at build time using `dms dank16`.
# Bypasses stylix for terminal colors — produces files directly.
#
{ lib }:

{
  dank16 = {
    # Generate Ghostty theme + fish color config from a matugen base16 scheme.
    #
    # Returns: derivation with ghostty-theme and fish-colors.fish
    mkTerminalThemes =
      {
        pkgs,
        dmsPackage,
        matugenBase16Scheme,
        polarity,
      }:
      assert polarity == "light" || polarity == "dark";
      let
        lightFlag = lib.optionalString (polarity == "light") "--light";
      in
      pkgs.runCommand "dank16-terminal-themes"
        {
          nativeBuildInputs = [
            dmsPackage
            pkgs.jq
            pkgs.gnugrep
            pkgs.gnused
          ];
        }
        ''
          set -euo pipefail
          mkdir -p $out

          # Extract colors from matugen base16 scheme
          extract() { grep "$1:" ${matugenBase16Scheme} | sed 's/.*"\([^"]*\)".*/\1/'; }

          BG=$(extract base00)
          FG=$(extract base05)
          PRIMARY=$(extract base0B)
          PRIMARY_CONTAINER=$(extract base0D)
          SURFACE_LOW=$(extract base02)
          ON_SURFACE_VARIANT=$(extract base04)

          if [ -z "$PRIMARY" ] || [ -z "$BG" ]; then
            echo "ERROR: Could not extract colors from scheme" >&2
            exit 1
          fi

          # Generate dank16 palette
          DANK16=$(dms dank16 "$PRIMARY" --background "$BG" ${lightFlag} --json)

          # Extract hex values
          c() { echo "$DANK16" | jq -r ".color$1.hex"; }

          # ── Ghostty theme ──
          cat > $out/ghostty-theme << EOF
          background = $BG
          foreground = $FG
          cursor-color = $PRIMARY
          selection-background = $PRIMARY_CONTAINER
          selection-foreground = $FG

          palette = 0=$(c 0)
          palette = 1=$(c 1)
          palette = 2=$(c 2)
          palette = 3=$(c 3)
          palette = 4=$(c 4)
          palette = 5=$(c 5)
          palette = 6=$(c 6)
          palette = 7=$(c 7)
          palette = 8=$(c 8)
          palette = 9=$(c 9)
          palette = 10=$(c 10)
          palette = 11=$(c 11)
          palette = 12=$(c 12)
          palette = 13=$(c 13)
          palette = 14=$(c 14)
          palette = 15=$(c 15)
          EOF

          # ── Fish colors ──
          # Syntax highlighting uses named ANSI colors (resolved via Ghostty palette)
          # Hex values used where subtle shading is needed
          cat > $out/fish-colors.fish << EOF
          set -U fish_color_normal normal
          set -U fish_color_command green
          set -U fish_color_keyword blue
          set -U fish_color_quote yellow
          set -U fish_color_redirection cyan
          set -U fish_color_end brblack
          set -U fish_color_error red
          set -U fish_color_param $ON_SURFACE_VARIANT
          set -U fish_color_comment $SURFACE_LOW
          set -U fish_color_autosuggestion $SURFACE_LOW
          set -U fish_color_operator blue
          set -U fish_color_escape yellow
          set -U fish_color_cwd green
          set -U fish_color_cwd_root red
          set -U fish_color_user brgreen
          set -U fish_color_host normal
          set -U fish_color_status red
          set -U fish_color_cancel -r
          set -U fish_color_search_match bryellow --background=$SURFACE_LOW
          set -U fish_color_selection white --bold --background=$SURFACE_LOW
          set -U fish_color_valid_path --underline
          set -U fish_color_history_current --bold
          set -U fish_color_match --background=brblue
          set -U fish_pager_color_completion normal
          set -U fish_pager_color_description yellow --dim
          set -U fish_pager_color_prefix white --bold
          set -U fish_pager_color_progress brwhite --background=cyan
          EOF
        '';
  };
}
