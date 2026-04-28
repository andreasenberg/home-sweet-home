{ ... }:
{
  flake.homeModules.helix =
    { lib, pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;
        settings = {
          theme = "catppuccin_mocha";
          editor = {
            bufferline = "multiple";
            cursorline = true;
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
          language-server.pyright = {
            command = "pyright-langserver";
            args = [ "--stdio" ];
            config.reportMissingtypeStubs = false;
            config.python.analysis.typeCheckingMode = "off";
          };

          language-server.ruff = {
            command = "ruff";
            args = [ "server" ];
          };

          language-server.pylsp.config.pylsp.plugins = {
            pylsp-mypy.enabled = true;
          };

          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = lib.getExe pkgs.nixfmt;
            }
            {
              name = "python";
              auto-format = true;
              language-servers = [
                {
                  name = "ruff";
                  only-features = [
                    "format"
                    "diagnostics"
                    "code-action"
                  ];
                }
                {
                  name = "pyright";
                  except-features = [
                    "format"
                    "diagnostics"
                  ];
                }
                {
                  name = "pylsp";
                  only-features = [
                    "diagnostics"
                    "code-action"
                  ];
                }
              ];
            }
          ];
        };
      };
    };
}
