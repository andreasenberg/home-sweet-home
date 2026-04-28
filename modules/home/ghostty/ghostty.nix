{ ... }:
{
  flake.homeModules.ghostty =
    { ... }:
    {
      # Installed via homebrew at the moment
      home.file = {
        ".config/ghostty/config" = {
          source = ./config;
        };
      };
    };
}
