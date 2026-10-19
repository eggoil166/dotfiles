{ pkgs, ... }:

{
  # theming
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Mauve-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override { accent = [ "mauve" ]; };
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # launcher
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    terminal = "ghostty";
    modes = [
      "drun"
      "run"
      "window"
    ];
    extraConfig = {
      show-icons = true;
      display-drun = "apps";
      display-run = "run";
      display-window = "windows";
      drun-display-format = "{name}";
    };
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-margin-top = 8;
      control-center-margin-right = 8;
      control-center-width = 420;
      notification-window-width = 400;
      timeout = 6;
      timeout-low = 3;
      timeout-critical = 0;
      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
    };
  };
  catppuccin.swaync.font = "JetBrainsMono Nerd Font";
}
