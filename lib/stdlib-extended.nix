{ inputs }:
self: super: {
  tmux = import ./. { inherit inputs self super; };
}
