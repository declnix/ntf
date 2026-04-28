{ inputs, self, super }:

let
  dag = inputs.dag.lib { lib = super; };
in

{
  entryAnywhere = dag.entryAnywhere;
  entryAfter = dag.entryAfter;
  entryBefore = dag.entryBefore;
  plugin = plugin: "source-file ${toString plugin}/tmux.plugin.sh";

  inherit dag;

  tmuxConfiguration = import ./tmuxConfiguration.nix { inherit inputs self super; };
}
