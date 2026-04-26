# options.nix — Declares mergeable flake-parts options
#
# Lives in the repo root alongside flake.nix rather than in modules/, since
# it is infrastructure for the flake-parts setup rather than a feature module.
# Imported explicitly in flake.nix via imports = [ ./options.nix ... ].
#
# WHY IS THIS NEEDED?
# nix-darwin's flake-parts integration (flakeModules.default) declares
# flake.darwinModules with the type `anything`, which only allows a single
# definition. This means that if multiple files try to set flake.darwinModules.*
# simultaneously, flake-parts complains that the option is defined multiple times.
#
# This file overrides that declaration with the type `attrsOf raw`, which:
#   - Allows each key (e.g. .system, .nix, .homebrew) to be defined in
#     separate files
#   - Automatically merges all definitions into a single attribute set
#   - Preserves functions and modules as-is without wrapping them (raw)
#
# This is what enables the dendritic pattern where each feature file can
# contribute its own darwinModule without any knowledge of the other files.

{ lib, ... }:
{
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
    description = ''
      Attribute set of nix-darwin modules collected by import-tree and
      included in darwinSystem via builtins.attrValues inputs.self.darwinModules.
    '';
  };
}
