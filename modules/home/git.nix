{ ... }:
{
  flake.homeModules.git =
    { ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          pull.ff = true;
          pull.rebase = true;

          init.defaultBranch = "main";

          # Show latest active branch at the top
          branch.sort = "-committerdate";
          aliases = {
            co = "checkout";
            br = "branch";
            st = "status";
            cmt = "commit";
            unstage = "restore --staged --";
            recent = "!git branch --sort=-committerdate | head -n10";
          };
        };
      };
    };
}
