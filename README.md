# ntf — Declarative Tmux Plugin Manager

A declarative tmux plugin manager written in Nix, inspired by the declarative approach of [nzf](https://github.com/declnix/nzf).

## Usage

The main API is `lib.tmux.tmuxConfiguration`, which takes a plugin configuration and generates tmux configuration:

```nix
lib.tmux.tmuxConfiguration {
  tmux-sensible.enable = true;
  tmux.settings = {
    mouse = true;
    base-index = 1;
  };
}
```

See [`devshell.nix`](./devshell.nix) for a complete working example.

## Home Manager Integration

You can easily integrate `ntf` with Home Manager by using the generated configuration:

```nix
{ inputs, pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    configText = inputs.ntf.lib.tmux.tmuxConfiguration {
      tmux-sensible.enable = true;
      tmux.settings = {
        mouse = true;
        base-index = 1;
      };
    } config.finalConfig;
  };
}
```

## How It Works

`tmuxConfiguration` takes your plugin definitions and:
1. Resolves plugin dependencies using DAG (Directed Acyclic Graph)
2. Generates tmux configuration in the correct order
3. Outputs plain tmux config that can be sourced anywhere

## API

**ntf helpers:**
- `plugin pkg` — Source a plugin from nixpkgs
- `entryAnywhere` — No ordering constraint
- `entryAfter deps` — Plugin ordering constraint
- `entryBefore deps` — Plugin ordering constraint

**DAG functions** (from [denful/dag](https://github.com/denful/dag)):
- `dag.entryAfter deps` — Plugin ordering constraint
- `dag.entryBefore deps` — Plugin ordering constraint
- `dag.entryAnywhere` — No ordering constraint

## Project Structure

- [`lib/`](./lib/) — Core library functions and helpers
- [`modules/`](./modules/) — Built-in plugin modules (e.g., sensible)
- [`devshell.nix`](./devshell.nix) — Example configuration and development environment
- [`.specs/`](./.specs/) — Design documents and specifications
- [`CONTRIBUTING.md`](./CONTRIBUTING.md) — Contribution guidelines

## See Also

- [denful/dag](https://github.com/denful/dag) — The underlying DAG library
