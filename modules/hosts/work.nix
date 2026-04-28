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
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."aenberg" = {
          imports = builtins.attrValues inputs.self.homeModules;
          home.username = "aenberg";
        };
      }
    ]
    ++ (builtins.attrValues inputs.self.darwinModules);
  };
}
