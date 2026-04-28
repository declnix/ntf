{ config, lib, dag, ... }:

{
  options.tmux = {
    plugins = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "this plugin";
          path = lib.mkOption {
            type = lib.types.str;
            description = "Path to the plugin";
          };
        };
      });
      default = {};
      description = "Tmux plugins to source";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [
        lib.types.bool
        lib.types.int
        lib.types.str
      ]);
      default = {};
      description = ''
        Tmux settings as key-value pairs.
        Values are automatically translated to tmux format:
        - Booleans: true → "on", false → "off"
        - Other types: converted to string
        Each setting is rendered as `set -g <key> <value>`.
      '';
      example = {
        mouse = true;
        base-index = 1;
        default-shell = "/bin/zsh";
      };
    };
  };

  config =
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
      # Prepend translated settings and plugin sources to extraConfig for rendering
      extraConfig = lib.mkBefore (lib.recursiveUpdate settingsToDag pluginSourceLines);
    };
}
