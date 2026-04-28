{ inputs, self, super }:
{
  tmuxConfiguration = import ./tmuxConfiguration.nix { inherit inputs self super; };
  dag = inputs.dag.lib { lib = super; };
}
