# Flux Schema Nix Flake

This repository contains a Nix flake for the [Flux Schema CLI](https://github.com/fluxcd/flux-schema). It allows people using Nix and NixOS to run the program.

## Installation

Add this flake to your own flake inputs:

```nix
{
  inputs.flux-schema-nix-flake.url = "github:TheColorman/flux-schema-nix-flake";

  outputs = inputs: { /* ... */ };
}
```

or you can optionally override this flake's inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flux-schema-nix-flake = {
      url = "github:TheColorman/flux-schema-nix-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs = inputs: { /* ... */ };
}
```

You can now reference the program in your config:

```nix
{ inputs, ... }:
{
  environment.systemPackages = [
    inputs.flux-schema-nix-flake.packages.x86_64-linux.flux-schema
  ];
}
```
