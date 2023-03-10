{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp.java;
in {
  options.vim.lsp = {
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
    '';
  };
}
