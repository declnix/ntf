{ pkgs, lib }:
let
  exampleConfig = lib.tmux.tmuxConfiguration {
    modules = [{
      tmux-sensible.enable = true;
      tmux.settings = {
        mouse = true;
        base-index = 1;
      };
    }];
  };
  tmuxConf = pkgs.writeTextDir "tmux.conf" exampleConfig.config.finalConfig;
in
pkgs.mkShell {
  packages = [ pkgs.nixfmt pkgs.tmux ];
  shellHook = ''
    export TMUX_CONF=${tmuxConf}/tmux.conf
    echo "ntf devshell ready"
  '';
}
