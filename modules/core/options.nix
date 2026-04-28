{ lib, ... }:

{
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
}
