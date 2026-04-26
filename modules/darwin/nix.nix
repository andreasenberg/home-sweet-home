{ ... }:
{
  flake.darwinModules.nix =
    {
      nixbldGid,
      username,
      ...
    }:
    {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      #environment.systemPackages =
      #  [
      #    pkgs.vim
      #  ];
      # Resolve activation error, "Build user group has mismatching GID, aborting activation", due to Sequoia mig script?
      ids.gids.nixbld = nixbldGid;
      # nix.package = pkgs.nix;

      # Enable a linux builder to build linux images on Mac OS
      nix.linux-builder = {
        enable = false;
        ephemeral = true; # wipe the builder’s filesystem on every restart
        config.virtualisation.cores = 4;
      };

      # Necessary for using flakes on this system.
      nix.settings = {
        extra-platforms = [ "aarch64-linux" ];
        trusted-users = [
          "root"
          "${username}"
        ];
        experimental-features = "nix-command flakes";
      };
    };

}
