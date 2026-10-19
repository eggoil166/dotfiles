{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      font-size = 11;
      font-family = "JetBrainsMono Nerd Font";
      window-padding-x = 10;
      window-padding-y = 10;
      background-opacity = 0.95;
      cursor-style = "block";
      # shell integration otherwise swaps to a bar cursor at the prompt
      shell-integration-features = "no-cursor";
      confirm-close-surface = false;
    };
  };
}
