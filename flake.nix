{
  description = "A Development Environment for team-nullpo/null-tasker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    treefmt-nix,
    pre-commit-hooks,
    ...
  }: flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter = treefmt-nix.lib.mkWrapper pkgs {
      projectRootFile = "flake.nix";
        programs.biome = {
          enable = true;
        };
      };

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            treefmt.enable = true;
          };
        };
      };
    
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_22
          pnpm
          biome
        ];
      };
    }
  );
}
