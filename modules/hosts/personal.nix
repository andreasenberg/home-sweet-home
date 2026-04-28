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
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."andreas" = {
          imports = builtins.attrValues inputs.self.homeModules;
          home.username = "andreas";
        };
      }
      # Append casks to defaults in homebrew module
      { homebrew.casks = [ "steam" ]; }
    ]
    ++ (builtins.attrValues inputs.self.darwinModules);
  };
}
