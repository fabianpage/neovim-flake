{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.java;
in {
  options.vim = {
    java = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable tmux-navigator, this plugin will only work together with tmuxPlugins.vim-tmux-navigator";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [
      "nvim-jdtls"
    ];

    vim.luaConfigRC = nvim.dag.entryAnywhere ''
      local config = {
        cmd = {'${pkgs.jdt-language-server}/bin/jdt-language-server'},
        root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
      }
      require('jdtls').start_or_attach(config)
      ${optionalString (cfg.autosave-on-leave == "update") "let g:tmux_navigator_save_on_switch = 1"}
      ${optionalString (cfg.autosave-on-leave == "wall") "let g:tmux_navigator_save_on_switch = 2"}
      ${optionalString (cfg.disable-when-zoomed) "let g:tmux_navigator_disable_when_zoomed = 1"}
      ${optionalString (cfg.preserve-zoom) "let g:tmux_navigator_preserve_zoom  = 1"}
    '';
  };
}
