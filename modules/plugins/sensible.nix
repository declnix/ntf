{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.tmux) entryAnywhere plugin;
  cfg = config.tmux-sensible;
in

{
  options.tmux-sensible = {
    enable = mkEnableOption "tmux-sensible plugin";
  };

  config = mkIf cfg.enable {
    plugins.tmux-sensible = entryAnywhere (plugin pkgs.tmuxPlugins.sensible);
  };
}
