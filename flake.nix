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

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
  }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#andreas
    darwinConfigurations."aenberg" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."aenberg" = {
            pkgs,
            config,
            lib,
            ...
          }:
            import ./home.nix {
              inherit pkgs config lib;
              username = "aenberg";
            };
        }
      ];
      specialArgs = {
        inherit inputs;
        username = "aenberg";
      };
    };
    darwinConfigurations."andreas" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."andreas" = {
            pkgs,
            config,
            lib,
            ...
          }:
            import ./home.nix {
              inherit pkgs config lib;
              username = "andreas";
            };
        }
      ];
      specialArgs = {
        inherit inputs;
        username = "andreas";
      };
    };
    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."andreas".pkgs;
  };
}
