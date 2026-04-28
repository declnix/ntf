{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault mkOption types;
  cfg = config.tmux-sensible;
in

{
  options.tmux-sensible = {
    enable = mkEnableOption "tmux-sensible plugin";
  };

  config = mkIf cfg.enable {
    tmux.plugins.sensible = {
      enable = true;
      path = pkgs.tmuxPlugins.sensible;
    };
  };
}
