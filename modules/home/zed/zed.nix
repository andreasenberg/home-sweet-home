{ ... }:
{
  flake.homeModules.zed =
    { ... }:
    {
      # Installed via homebrew at the moment
      home.file = {
        ".config/zed/settings.json" = {
          source = ./settings.json;
          force = true;
        };

        ".config/zed/keymap.json" = {
          source = ./keymap.json;
          force = true;
        };

      };
    };
}
