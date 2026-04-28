{
  description = "Deskorolka foundation";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    dag.url = "github:denful/dag";
  };
  outputs = inputs@{ self, flake-parts, nixpkgs, dag }:
    let
      lib = nixpkgs.lib.extend (import ./lib/stdlib-extended.nix { inherit inputs; });
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      flake = {
        inherit lib;
      };
    };
}
