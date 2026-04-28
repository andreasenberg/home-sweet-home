{ ... }:
{
  flake.homeModules.starship =
    { ... }:
    {
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = builtins.fromTOML (builtins.readFile ./settings.toml);
      };
    };
}
