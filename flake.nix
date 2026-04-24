{
  description = "Home sweet home - system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
  };

  # Build darwin flake using:
  # $ darwin-rebuild build --flake .#andreas
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-darwin.flakeModules.default # activate flake.darwinModules
        inputs.home-manager.flakeModules.default # activate flake.homeModules
        (inputs.import-tree ./modules)
      ];
    };
}
