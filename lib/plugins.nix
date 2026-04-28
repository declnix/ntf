{ lib, ... }:

{
  # Generate a source-file command for a plugin path
  pluginSource = path: "source-file ${path}/tmux.plugin.sh";

  # Filter enabled plugins and return their source commands
  enabledPluginCommands = plugins:
    lib.pipe plugins [
      # Filter only enabled plugins
      (lib.filterAttrs (_: plugin: plugin.enable or false))
      # Map each to its source command
      (lib.mapAttrsToList (_: plugin: "${plugin.path}/tmux.plugin.sh"))
      # Map each to a source-file command
      (map (path: "source-file ${path}"))
    ];

  # Convert plugin path to a DAG entry for sourcing
  pluginToDagEntry = name: path:
    lib.dag.entry lib.dag.entryAnywhere "source-file ${path}/tmux.plugin.sh";
}
