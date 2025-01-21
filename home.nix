{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  localAbbreviationsPath = "/Users/${username}/.config/fish/local-abbr.fish";
  fishAbbreviations = lib.concatStringsSep "\n" (
    map builtins.readFile [
      # tracked abbreviations
      #./fish/prompt.fish
      ./fish/abbr.fish
      ./fish/homebrew.fish
      ./fish/jujutsu.fish # https://jj-vcs.github.io/jj/latest/install-and-setup/#fish
      #(pkgs.fetchurl {
      #  url = "https://iterm2.com/shell_integration/fish";
      #  hash = "sha256-tdn4z0tIc0nC5nApGwT7GYbiY91OTA4hNXZDDQ6g9qU=";
      #})
    ]
  );
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  #home.username = "aenberg";
  #home.homeDirectory = "/Users/aenberg";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # coreutils
    curl
    htop
    jq
    nerd-fonts.hack
    nixfmt-rfc-style
    nodejs
    spacer
    unixtools.watch

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.runCommand "all-the-pythons" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.python312}/bin/python $out/bin/python3
      ln -s ${pkgs.python312}/bin/python $out/bin/python

      ln -s ${pkgs.python311}/bin/python $out/bin/python3.11
      ln -s ${pkgs.python312}/bin/python $out/bin/python3.12
      ln -s ${pkgs.python313}/bin/python $out/bin/python3.13
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".psqlrc".text = ''
      \set QUIET ON
      \pset null 'NULL'
      \timing
      \set COMP_KEYWORD_CASE upper
      \set QUIET OFF
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aenberg/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    LANG = "en_US.UTF-8";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      br = "branch";
      st = "status";
      cmt = "commit";
      unstage = "restore --staged --";
      recent = "!git branch --sort=-committerdate | head -n10";
    };

    extraConfig = {
      pull.ff = true;
      pull.rebase = true;

      init.defaultBranch = "main";

      # Show latest active branch at the top
      branch.sort = "-committerdate";
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Andreas Enberg";
      };

      ui = {
        default-command = "log";
        merge-editor = "vscode";

        default-description = ''
          JJ: If applied, this commit will...

          JJ: Explain why this change is being made

          JJ: Provide links to any relevant tickets, articles or other resources

          JJ: -------------------------------------------
        '';
      };

      colors = {
        timestamp = "bright black";
      };
    };
  };

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
    plugins = with pkgs.fishPlugins; [
      #{
      #  name = "done";
      #  src = done.src;
      #}
      #{name = "grc"; src = grc.src;}
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      package.disabled = true;
      python.disabled = true;
      nodejs.disabled = true;
      git_branch.disabled = true;
      git_commit.disabled = true;
      git_state.disabled = true;
      git_metrics.disabled = true;
      git_status.disabled = true;

      # https://github.com/martinvonz/jj/wiki/Starship
      custom.jj = {
        when = true;
        description = "current jj status";
        symbol = "";
        command = ''
          jj root > /dev/null && jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
            separate(" ",
              "🥋",
              change_id.shortest(4),
              bookmarks,
              "|",
              concat(
                if(conflict, "💥"),
                if(divergent, "🚧"),
                if(hidden, "👻"),
                if(immutable, "🔒"),
              ),
              raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
              raw_escape_sequence("\x1b[1;32m") ++ if(description.first_line().len() == 0,
                "(no description set)",
                if(description.first_line().substr(0, 29) == description.first_line(),
                  description.first_line(),
                  description.first_line().substr(0, 29) ++ "…",
                )
              ) ++ raw_escape_sequence("\x1b[0m"),
            )
          '
        '';
      };
      custom.git_branch = {
        when = true;
        description = "Only show git_branch if we're not in a jj repo";
        command = "jj root >/dev/null 2>&1 || starship module git_branch";
      };
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "molokai";
      editor = {
        bufferline = "multiple";
        color-modes = true;
        file-picker.hidden = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
        }
      ];
    };
  };
}
