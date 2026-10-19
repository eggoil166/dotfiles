{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-config/home/dotfiles";
in
{
  imports = [
    ./apps.nix
    ./desktop.nix
    ./hyprland.nix
    ./shell.nix
    ./terminal.nix
    ./waybar.nix
  ];

  home.username = "eggoil";
  home.homeDirectory = "/home/eggoil";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    hyprland.enable = false;
  };

  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
    # editor / dev
    neovim
    clang
    clang-tools
    cmake
    ninja
    gnumake
    gdb
    pkg-config
    rustup
    verilator
    yosys

    # language servers etc. for lazyvim
    lua-language-server
    stylua
    nixd
    nixfmt
    ruff
    asm-lsp
    tree-sitter

    # cli
    ripgrep
    fd
    unzip
    tree
    fastfetch
    stress

    # apps
    vesktop
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
    "eww".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/eww";
  };

  home.file.".local/bin/driftwm-dev" = {
    executable = true;
    text = ''
      #!/bin/sh
      exec >/tmp/driftwm-dev.log 2>&1
      echo "=== driftwm-dev session start $(date) ==="
      cd "$HOME/src/driftwm"
      exec nix develop --command ./target/release/driftwm
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    settings.user.name = "eggoil166";
    settings.user.email = "daniel.yi166@gmail.com";
  };
}
