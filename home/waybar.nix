{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      spacing = 4;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "custom/notification"
        "pulseaudio"
        "bluetooth"
        "network"
        "cpu"
        "memory"
        "battery"
        "custom/power"
        "tray"
      ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          active = "";
          default = "";
        };
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 50;
        separate-outputs = true;
      };

      clock = {
        format = "{:%a %d %b  %H:%M}";
        tooltip-format = "<tt><big>{calendar}</big></tt>";
        on-click = "eww open --toggle calendar";
      };

      cpu = {
        format = " {usage}%";
        interval = 5;
        on-click = "eww open --toggle sysinfo";
      };
      memory = {
        format = "󰍛 {percentage}%";
        interval = 5;
        on-click = "eww open --toggle sysinfo";
      };

      battery = {
        bat = "BAT0";
        adapter = "AC";
        interval = 60;

        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}% ({time})";
        format-plugged = "󰂄 {capacity}%";
        format-discharging = "{icon} {capacity}% ({time})";
        format-icons = [
          "󰁺"
          "󰁼"
          "󰁾"
          "󰂀"
          "󰂂"
        ];
        states = {
          warning = 20;
          critical = 10;
        };
        on-click = "eww open --toggle sysinfo";
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = "󰡹 wired";
        format-disconnected = "󰖪";
        tooltip-format = "{ifname}: {ipaddr}";
        on-click = "eww open --toggle wifi";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        max-volume = 100;
        format-icons = {
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      "custom/power" = {
        format = "";
        tooltip = false;
        on-click = "eww open --toggle power";
      };

      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-connected = "󰂱 {device_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "blueman-manager";
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "󰂞";
          none = "󰂚";
          dnd-notification = "󰂛";
          dnd-none = "󰂛";
        };
        return-type = "json";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      tray = {
        spacing = 8;
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        font-weight: 600;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: @text;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background-color: alpha(@base, 0.75);
        border-radius: 14px;
        padding: 0 8px;
        margin: 0 2px;
        border: 2px solid alpha(@surface0, 0.8);
      }

      #workspaces button {
        color: @overlay0;
        padding: 0 6px;
        border-radius: 10px;
        transition: all 0.2s ease;
      }
      #workspaces button.active {
        color: @base;
        background-color: @mauve;
        border-radius: 10px;
      }
      #workspaces button:hover {
        color: @text;
        background-color: @surface1;
      }

      #window { color: @subtext0; padding: 0 10px; }

      #clock {
        color: @mauve;
        padding: 0 12px;
        font-weight: 700;
      }

      #cpu { color: @peach; padding: 0 8px; }
      #memory { color: @yellow; padding: 0 8px; }
      #network { color: @blue; padding: 0 8px; }
      #bluetooth { color: @sky; padding: 0 8px; }
      #pulseaudio { color: @teal; padding: 0 8px; }
      #battery { color: @green; padding: 0 8px; }
      #battery.warning { color: @yellow; }
      #battery.critical { color: @red; }
      #custom-notification { color: @lavender; padding: 0 8px; }
      #custom-power { color: @red; padding: 0 10px; }
      #tray { padding: 0 8px; }
    '';
  };
}
