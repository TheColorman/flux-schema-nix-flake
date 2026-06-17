{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];
        systems = lib.systems.flakeExposed;

        perSystem = {
          pkgsDirectory = ./pkgs;
        };
      }
    );
}
