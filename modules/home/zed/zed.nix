{ ... }:
{
  flake.homeModules.zed =
    { config, ... }:
    {
      # Installed via homebrew at the moment
      home.file = {
        ".config/zed/settings.json" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/modules/home/zed/settings.json";
          force = true;
        };

        ".config/zed/keymap.json" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/modules/home/zed/keymap.json";
          force = true;
        };

      };
    };
}
