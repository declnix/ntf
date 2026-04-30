{ config, lib, dag, ... }:

let
  wrapEntry = name: value:
    if lib.isString value then
      dag.entryAnywhere value
    else
      value;

  wrappedEntries = lib.mapAttrs wrapEntry config.tmux.plugins;
in

{
  options = {
    finalConfig = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "The fully rendered tmux configuration file.";
    };
  };

  config = {
    finalConfig = dag.render { entries = wrappedEntries; separator = "\n"; };
  };
}
