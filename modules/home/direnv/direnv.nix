{ ... }:
{
  flake.homeModules.direnv =
    { ... }:
    {
      programs.direnv.enable = true;
      home.file = {
        ".config/direnv/direnv.toml" = {
          source = ./settings.toml;
        };
      };
    };
}
