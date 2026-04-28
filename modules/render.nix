{ config, lib, dag, ... }:

let
  # Convert raw strings to DAG entries, keep existing entries as-is
  wrapEntry = name: value:
    if lib.isString value then
      dag.entryAnywhere value
    else
      value;

  wrappedEntries = lib.mapAttrs wrapEntry config.extraConfig;
in

{
  options = {
    extraConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
      description = "Extra configuration lines as a DAG.";
    };

    finalConfig = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "The fully rendered configuration file.";
    };
  };

  config = {
    finalConfig = dag.render { entries = wrappedEntries; };
  };
}
