{ ... }:
{
  flake.homeModules.tools =
    { pkgs, ... }:
    let
      catppuccin-k9s = builtins.fetchGit {
        url = "https://github.com/catppuccin/k9s.git";
        rev = "4432383da214face855a873d61d2aa914084ffa2";
      };

    in
    {
      # The home.packages option allows you to install Nix packages into your
      # environment.
      home.packages = with pkgs; [
        # coreutils
        curl
        difftastic
        fd
        htop
        jq
        nerd-fonts.hack
        nil
        nixfmt
        nodejs
        podman
        ripgrep
        shellcheck
        skopeo
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

      programs.fzf.enable = true;

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

        "Library/Application Support/k9s/skins/catppuccin-mocha.yaml" = {
          source = "${catppuccin-k9s}/dist/catppuccin-mocha.yaml";
        };
      };
    };
}
