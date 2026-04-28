{ ... }:
{
  flake.homeModules.jujutsu =
    { ... }:
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Andreas Enberg";
          };

          ui = {
            default-command = "log";
            merge-editor = "vscode";
            conflict-marker-style = "git";
            diff-formatter = [
              "difft"
              "--color=always"
              "$left"
              "$right"
            ];
          };

          colors = {
            timestamp = "bright black";
          };

          template-aliases = {
            # Set username instead of email because domain is reduntant.
            "format_short_signature(signature)" = "signature.email().local()";

            default_commit_description = ''
              "JJ: If applied, this commit will...

              JJ: Explain why this change is being made

              JJ: Provide links to any relevant tickets, articles or other resources

              JJ: -------------------------------------------

              "
            '';
          };
        };
      };
    };
}
