{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = "fastfetch";
    shellAliases = {
      ls = "eza";
      cat = "bat";
      ll = "eza -l --icons";
      vi = "nvim";
      vim = "nvim";
      lg = "lazygit";
    };
  };

  home.packages = with pkgs; [
    dust
    duf
    hyperfine
  ];

  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.btop.enable = true;
  programs.jq.enable = true;
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 1000;
    };
  };

  programs.zoxide.enable = true;

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      inline_height = 20;
      auto_sync = false;
      update_check = false;
    };
  };

  programs.lazygit.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };
  programs.gh.enable = true;
}
