{ pkgs, lib, ... }:

let
  workspaces = lib.genList (i: toString (i + 1)) 9;
in
{
  home.packages = with pkgs; [
    awww
    eww
    wl-clipboard
    grim
    slurp
    grimblast
    brightnessctl
    playerctl
    libnotify
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    # NIX_XDG_DESKTOP_PORTAL_DIR and hides the gtk portal
    portalPackage = null;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$launcher" = "rofi -show drun";
      exec-once = [
        "awww-daemon"
        "eww daemon"
      ];
      monitor = ",preferred,auto,1";

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 4;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        resize_on_border = true;
      };

      layerrule = [
        "blur on, match:namespace = waybar"
        "ignore_alpha 1, match:namespace = waybar"
        "blur on, match:namespace = eww-keybinds"
        "ignore_alpha 0.3, match:namespace = eww-keybinds"
        "blur on, match:namespace = rofi"
        "blur on, match:namespace = swaync-control-center"
        "blur on, match:namespace = swaync-notification-window"
        "ignore_alpha 0.5, match:namespace = swaync-control-center"
        "ignore_alpha 0.5, match:namespace = swaync-notification-window"
      ];

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.75;

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(11111baa)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "smoothOut, 0.36, 0, 0.66, -0.56"
        ];
        animation = [
          "windows, 1, 4, easeOutQuint, slide"
          "windowsOut, 1, 3, smoothOut, slide"
          "border, 1, 6, default"
          "fade, 1, 4, default"
          "workspaces, 1, 5, easeOutQuint, slide"
        ];
      };

      dwindle.preserve_split = true;

      input.touchpad.natural_scroll = true;

      gesture = [ "3, horizontal, workspace" ];

      windowrule = [
        "float on, match:class ^(org.pulseaudio.pavucontrol)$"
        "float on, match:class ^(.blueman-manager-wrapped|blueman-manager)$"
        "float on, match:class ^(nm-connection-editor)$"
        "float on, match:class ^(org.gnome.seahorse.Application)$"
        "float on, match:class ^(imv)$"
        "float on, match:class ^([Tt]hunar)$, match:title ^(File Operation Progress)$"

        "float on, match:class ^(xdg-desktop-portal-gtk)$"
        "center on, match:class ^(xdg-desktop-portal-gtk)$"
        "size 900 600, match:class ^(xdg-desktop-portal-gtk)$"

        "float on, match:title ^(Picture-in-Picture)$"
        "pin on, match:title ^(Picture-in-Picture)$"
        "keep_aspect_ratio on, match:title ^(Picture-in-Picture)$"
        "size 480 270, match:title ^(Picture-in-Picture)$"
        "move 100%-w-20 100%-h-20, match:title ^(Picture-in-Picture)$"
      ];

      bindd = [
        "$mod, slash, Show keybinds, exec, eww update keybinds=\"$(~/.config/eww/scripts/keybinds)\" && eww open --toggle keybinds"
        "$mod, Return, Terminal, exec, $terminal"
        "$mod, D, App launcher, exec, $launcher"
        "$mod, E, File manager, exec, thunar"
        "$mod SHIFT, V, Clipboard history, exec, cliphist list | rofi -dmenu -display-columns 2 -p clipboard | cliphist decode | wl-copy"
        "$mod, N, Notifications, exec, swaync-client -t -sw"
        "$mod, L, Lock screen, exec, loginctl lock-session"

        "$mod, Q, Close window, killactive"
        "$mod, V, Toggle floating, togglefloating"
        "$mod, F, Fullscreen, fullscreen"
        "$mod, J, Toggle split, layoutmsg, togglesplit"
        "$mod, M, Exit Hyprland, exit"

        "$mod, left, Focus window, movefocus, l"
        "$mod, right, Focus window, movefocus, r"
        "$mod, up, Focus window, movefocus, u"
        "$mod, down, Focus window, movefocus, d"
        "$mod SHIFT, left, Move window, movewindow, l"
        "$mod SHIFT, right, Move window, movewindow, r"
        "$mod SHIFT, up, Move window, movewindow, u"
        "$mod SHIFT, down, Move window, movewindow, d"

        "$mod, S, Scratchpad, togglespecialworkspace, scratch"
        "$mod SHIFT, S, Send to scratchpad, movetoworkspace, special:scratch"

        ", Print, Screenshot area, exec, grimblast --notify copysave area"
        "SHIFT, Print, Screenshot screen, exec, grimblast --notify copysave output"
        "$mod, Print, Screenshot window, exec, grimblast --notify copysave active"
      ]
      ++ map (ws: "$mod, ${ws}, Go to workspace, workspace, ${ws}") workspaces
      ++ map (ws: "$mod SHIFT, ${ws}, Send to workspace, movetoworkspace, ${ws}") workspaces;

      bindmd = [
        "$mod, mouse:272, Drag window, movewindow"
        "$mod, mouse:273, Resize window, resizewindow"
      ];

      bindel = [
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  services.hyprpolkitagent.enable = true;

  services.cliphist.enable = true;

  services.hyprsunset = {
    enable = true;
    settings.profile = [
      {
        time = "7:00";
        identity = true;
      }
      {
        time = "20:30";
        temperature = 4500;
      }
    ];
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  catppuccin.hyprlock.useDefaultConfig = false;
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.6;
        }
      ];
      label = [
        {
          text = "$TIME";
          color = "$text";
          font_size = 90;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:60000] date +"%A, %B %d"'';
          color = "$subtext1";
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          size = "300, 55";
          outline_thickness = 3;
          rounding = 14;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          check_color = "$green";
          fail_color = "$red";
          capslock_color = "$yellow";
          placeholder_text = "<span foreground=\"##$overlay1Alpha\">password…</span>";
          fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
          fade_on_empty = false;
          dots_center = true;
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # wallpaper rotation
  home.file.".local/bin/rotate-wallpaper" = {
    executable = true;
    text = ''
      #!/bin/sh
      WALLDIR="$HOME/Pictures/wallpapers"
      IMG=$(find "$WALLDIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n1)
      [ -n "$IMG" ] && ${pkgs.awww}/bin/awww img "$IMG" --transition-type any --transition-fps 60
    '';
  };

  systemd.user.services.wallpaper-rotate = {
    Unit.Description = "Rotate wallpaper";
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/rotate-wallpaper";
    };
  };

  systemd.user.timers.wallpaper-rotate = {
    Unit.Description = "rotate wallpaper every 2 min";
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "2min";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
