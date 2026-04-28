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

  # Generate source-file commands for enabled plugins
  enabledPlugins = lib.filterAttrs (_: plugin: plugin.enable or false) config.tmux.plugins;
  pluginSourceLines = lib.mapAttrs (name: plugin:
    dag.entryAnywhere "source-file ${toString plugin.path}/tmux.plugin.sh"
  ) enabledPlugins;
in

{
  config = {
    # Prepend translated settings and plugin sources to extraConfig for rendering
    extraConfig = lib.mkBefore (lib.recursiveUpdate settingsToDag pluginSourceLines);
  };
}
