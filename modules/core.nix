{ config, lib, dag, pkgs, ... }:

let
  # Normalize setting values to tmux format
  normalizeValue = value:
    if lib.isBool value then
      (if value then "on" else "off")
    else if lib.isInt value then
      toString value
    else
      ''"${lib.escape [ "\"" "\\" ] (toString value)}"'';

  # Submodule module for tmux settings and plugins DAG
  settingsModule = { config, lib, dag, ... }:
    let
      # Filter config to only scalar settings (excluding declared options)
      settings = lib.filterAttrs (name: value:
        name != "plugins" &&
        (lib.isBool value || lib.isInt value || lib.isString value)
      ) config;

      # Transform settings into DAG entries
      settingsToDag = lib.mapAttrs (name: value:
        dag.entryAnywhere "set -g ${name} ${normalizeValue value}"
      ) settings;
    in
    {
      options.plugins = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {};
        description = "Tmux plugins as a DAG.";
      };

      config = {
        _module.freeformType = lib.types.attrsOf (lib.types.oneOf [
          lib.types.bool
          lib.types.int
          lib.types.str
        ]);
        plugins = lib.mkBefore settingsToDag;
      };
    };
in

{
  options.tmux = lib.mkOption {
    default = {};
    type = lib.types.submoduleWith {
      modules = [
        settingsModule
        ./plugins/sensible.nix
      ];
      specialArgs = { inherit dag pkgs; };
    };
    description = "Tmux configuration: settings and plugins.";
  };
}
