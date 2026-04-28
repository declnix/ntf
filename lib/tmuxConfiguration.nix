{ inputs, self, super }:
{ modules ? [], specialArgs ? {}, system ? "x86_64-linux" }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
self.evalModules {
  modules = [
    ../modules
    {
      _module.args = {
        inherit (self.tmux) dag;
        inherit pkgs;
      };
    }
  ] ++ modules;
  specialArgs = { inherit inputs; } // specialArgs;
}
