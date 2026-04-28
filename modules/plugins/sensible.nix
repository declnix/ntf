{ lib, config, pkgs, ... }:

{
  config = lib.mkIf (config.tmux.plugins.sensible.enable or false) {
    tmux.plugins.sensible = {
      path = lib.mkDefault pkgs.tmuxPlugins.sensible;
    };
  };
}
