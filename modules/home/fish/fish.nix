{ ... }:
{
  flake.homeModules.fish =
    { config, lib, ... }:
    let
      # Used within fish context so ~ can be used here
      localAbbreviationsPath = "~/.config/fish/local-abbr.fish";
      fishAbbreviations = lib.concatStringsSep "\n" (
        map builtins.readFile [
          # tracked abbreviations
          #./prompt.fish
          ./abbr.fish
          ./homebrew.fish
          ./jujutsu.fish # https://jj-vcs.github.io/jj/latest/install-and-setup/#fish
          ./podman.fish
        ]
      );
    in
    {
      programs.fish = {
        enable = true;

        loginShellInit = ''
          # This is needed to workaround the PATH being set in the wrong order.
          # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1030877541
          fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

          set -g fish_greeting
          #set __done_min_cmd_duration 2000
        '';
        interactiveShellInit = ''
          # Base abbr config
          ${fishAbbreviations}

          # Source local config if it exists
          if test -f "${localAbbreviationsPath}"
            source "${localAbbreviationsPath}"
          end
        '';
        # plugins = with pkgs.fishPlugins; [
        #{
        #  name = "done";
        #  src = done.src;
        #}
        #{name = "grc"; src = grc.src;}
        # ];
      };
    };
}
