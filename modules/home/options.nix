{ ... }:
{
  flake.homeModules.options =
    { lib, ... }:
    {
      options.dotfiles.repoPath = lib.mkOption {
        type = lib.types.str;
        description = "Absolute path to the nix config repo on this host";
      };
    };
}
