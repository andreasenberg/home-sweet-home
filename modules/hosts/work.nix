{ inputs, ... }:
{
  flake.darwinConfigurations.work = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      username = "aenberg";
      nixbldGid = 30000;
      configRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
    modules = [
      ../../darwin.nix
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          username = "aenberg";
        };
        home-manager.users."aenberg" = import ../../home.nix;
      }
    ];
  };
}
