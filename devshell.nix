{ pkgs, lib }:
let
  tmuxConf = pkgs.writeTextDir "tmux.conf" (lib.tmux.tmuxConfiguration {
    modules = [{
      tmux.tmux-sensible.enable = true;
      tmux.mouse = true;
      tmux.base-index = 1;
    }];
  });
in
pkgs.mkShell {
  packages = [ pkgs.nixfmt pkgs.tmux ];
  shellHook = ''
    export TMUX_CONF=${tmuxConf}/tmux.conf
    echo "ntf devshell ready"
  '';
}
