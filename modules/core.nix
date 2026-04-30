{ config, lib, dag, ... }:

{
  options = {
    plugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Tmux plugins as a DAG.";
    };
  };

  options.tmux = {
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
        - Integers: converted to string without quoting
        - Strings: wrapped in double quotes, with internal " and \ escaped
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
        else if lib.isInt value then
          toString value
        else
          ''"${lib.escape [ "\"" "\\" ] (toString value)}"'';

      # Transform settings into DAG entries
      settingsToDag = lib.mapAttrs (name: value:
        dag.entryAnywhere "set -g ${name} ${normalizeValue value}"
      ) config.tmux.settings;
    in
    {
      # Prepend translated settings to plugins for rendering
      plugins = lib.mkBefore settingsToDag;
    };
}
