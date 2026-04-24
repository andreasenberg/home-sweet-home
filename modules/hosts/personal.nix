{ inputs, ... }:
{
  flake.darwinConfigurations.personal = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      username = "andreas";
      nixbldGid = 350;
      configRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
    modules = [
      ../../darwin.nix
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          username = "andreas";
        };
        home-manager.users."andreas" = import ../../home.nix;
      }
    ];
  };
}
