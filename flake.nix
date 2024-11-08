{
  description = "Andreas Darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager setup
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
  let
    username = "aenberg"; #builtins.getEnv "USER";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#andreas
    darwinConfigurations."andreas" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = { pkgs, config, lib, ... }:
            import ./home.nix {
              inherit pkgs config lib username;
            };
        }
      ];
      specialArgs = {
        inherit inputs;
        inherit username;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."andreas".pkgs;
  };
}
