{
  pkgs,
  inputs,
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

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Enable a linux builder to build linux images on Mac OS
  nix.linux-builder = {
    enable = true;
    ephemeral = true; # wipe the builder’s filesystem on every restart
    config.virtualisation.cores = 6;
  };

  # Necessary for using flakes on this system.
  nix.settings = {
    trusted-users = [
      "root"
      "${username}"
    ];
    experimental-features = "nix-command flakes";
  };
  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  security.pam.enableSudoTouchIdAuth = true;

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

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  # Homebrew
  homebrew = {
    enable = true;

    casks = [
      "docker"
      "iterm2"
      "spotify"
      "visual-studio-code"
    ];
  };
}
