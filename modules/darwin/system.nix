{ ... }:
{
  flake.darwinModules.system =
    { configRevision, username, ... }:
    {
      # Set "primary user"
      system.primaryUser = "${username}";
      users.users.${username} = {
        name = "${username}";
        home = "/Users/${username}";
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = configRevision;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # System configs
      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      system.defaults = {
        # https://www.stefanjudis.com/blog/why-i-dont-need-to-clean-up-my-desktop-and-downloads-folder-in-macos/
        screencapture.location = "/private/tmp";
        dock = {
          autohide = true;
          tilesize = 55;
          largesize = 65;
          magnification = true;
          show-recents = false;
        };

        controlcenter = {
          Bluetooth = true;
        };

        NSGlobalDomain = {
          "com.apple.swipescrolldirection" = false;
        };
      };
    };

}
