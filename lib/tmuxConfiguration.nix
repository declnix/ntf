{ inputs, self, super }:
{ modules ? [], specialArgs ? {} }:
self.evalModules {
  modules = [
    ../modules/default.nix
    {
      _module.args = {
        inherit (self) tmux;
        inherit (self.tmux) dag;
      };
    }
  ] ++ modules;
  specialArgs = { inherit inputs; } // specialArgs;
}
