{ lib, ... }:

{
  options.tmux.plugins = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "this tmux plugin";
        path = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Path to the plugin";
        };
      };
    });
    default = {};
    description = ''
      Tmux plugins to source in the configuration.
      Each plugin can be enabled/disabled and has a path that will be sourced.
    '';
    example = {
      sensible = {
        enable = true;
        path = "/nix/store/..../sensible/share/tmux-plugins/sensible";
      };
    };
  };
}
