{ ... }:
{
  flake.darwinModules.homebrew =
    { ... }:
    {
      homebrew = {
        enable = true;
        # brew uninstall --zap all installed formulas not present in the generated brew file
        onActivation.cleanup = "uninstall";
        casks = [
          "ghostty"
          "inkscape"
          "spotify"
          "visual-studio-code"
          "zed"
        ];
      };
    };
}
