{ config, lib, dag, ... }:

let
  # Normalize setting values to tmux format
  normalizeValue = value:
    if lib.isBool value then
      (if value then "on" else "off")
    else
      toString value;

  # Transform settings into DAG entries
  settingsToDag = lib.mapAttrs (name: value:
    dag.entryAnywhere "set -g ${name} ${normalizeValue value}"
  ) config.tmux.settings;
in

{
  config = {
    # Merge translated settings into extraConfig for rendering
    extraConfig = settingsToDag // config.extraConfig;
  };
}
