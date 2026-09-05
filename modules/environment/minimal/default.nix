{ config, pkgs, lib, ... }:

let
  # ── awww: установка обоев (демон запускается systemd-сервисом) ──
  # Ставит первый найденный файл из папки ~/wallpapers (png/jpg/jpeg/webp/gif).
  # Поменять обои: awww img /path/to/img
  awww-init = pkgs.writeShellScriptBin "awww-init" ''
    sleep 1
    dir="$HOME/wallpapers"
    if [ -d "$dir" ]; then
      img=$(find "$dir" -maxdepth 1 -type f \
        \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \
           -o -iname "*.webp" -o -iname "*.gif" \) | head -n1)
      if [ -n "$img" ]; then
        ${pkgs.awww}/bin/awww img "$img" >/dev/null 2>&1 &
      fi
    fi
  '';

  # ── Waybar config (JSON) ─────────────────────────────────────
  waybar-config = pkgs.writeText "config.jsonc" ''
    {
      "layer": "top",
      "position": "top",
      "height": 26,
      "spacing": 4,
      "margin-top": 0,
      "margin-left": 0,
      "margin-right": 0,
      "margin-bottom": 0,
      "modules-left": ["wlr/workspaces", "mpris"],
      "modules-center": ["clock"],
      "modules-right": ["tray", "memory", "pulseaudio", "custom-notifications", "custom-power"],

      "wlr/workspaces": {
        "format": "{name}",
        "on-click": "activate",
        "sort-by-number": true,
        "active-only": false
      },

      "mpris": {
        "format": "{status_icon}  {dynamic}",
        "format-paused": "{status_icon}  {dynamic}",
        "status-icons": {
          "playing": "▶",
          "paused": "⏸"
        },
        "dynamic-order": ["title", "artist"],
        "max-length": 40,
        "on-click": "playerctl play-pause",
        "on-scroll-up": "playerctl next",
        "on-scroll-down": "playerctl previous"
      },

      "clock": {
        "format": "{:%H:%M}",
        "tooltip-format": "{:%A, %d %B %Y}"
      },

      "memory": {
        "format": "{}",
        "format-alt": "{used:.0f}M/{total:.0f}M",
        "tooltip-format": "{used:.0f}M / {total:.0f}M"
      },

      "pulseaudio": {
        "format": "{volume}%",
        "format-muted": "muted",
        "tooltip-format": "{desc}: {volume}%",
        "on-click": "pamixer -t",
        "on-scroll-up": "pamixer -i 5",
        "on-scroll-down": "pamixer -d 5"
      },

      "tray": {
        "icon-size": 14,
        "spacing": 4
      },

      "custom-notifications": {
        "format": "{}",
        "exec": "makoctl list 2>/dev/null | grep -c '\"app-name\"' || echo 0",
        "on-click": "makoctl dismiss"
      },

      "custom-power": {
        "format": "⏻",
        "tooltip": "Power menu",
        "on-click": "swaylock -c 111111"
      }
    }
  '';

in
{
  # ╔══════════════════════════════════════════════════════════════╗
  # ║  DWL Window Manager                                        ║
  # ╚══════════════════════════════════════════════════════════════╝
  programs.dwl = {
    enable = true;
    package = pkgs.dwl.override {
      configH = ./dwl-config.h;
    };
    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=dwl
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export GDK_BACKEND=wayland,x11
      export NIXOS_OZONE_WL=1

      # Автозапуск приложений ПОСЛЕ подъёма compositor (DWL)
      # extraSessionCommands исполняется только в сессии dwl (не в Hyprland)
      (sleep 2; ${pkgs.mako}/bin/mako) &
      (sleep 2; ${pkgs.waybar}/bin/waybar) &
      (sleep 2; ${pkgs.awww}/bin/awww-daemon) &
      (sleep 3; ${awww-init}/bin/awww-init) &
      (sleep 2; ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store) &
    '';
  };

  # ╔══════════════════════════════════════════════════════════════╗
  # ║  Packages                                                   ║
  # ╚══════════════════════════════════════════════════════════════╝
  environment.systemPackages = with pkgs; [
    waybar
    mako
    foot
    fuzzel
    yazi
    swaylock
    playerctl
    awww
    awww-init
    cliphist
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
  ];

  # ╔══════════════════════════════════════════════════════════════╗
  # ║  Config files (foot, fuzzel, swaylock)                    ║
  # ╚══════════════════════════════════════════════════════════════╝
  environment.etc = {
    "xdg/foot/foot.ini".source = ./foot.ini;
    "xdg/fuzzel/fuzzel.ini".source = ./fuzzel.ini;
    "xdg/swaylock/config".source = ./swaylock.ini;
    "xdg/waybar/config.jsonc".source = waybar-config;
    "xdg/waybar/style.css".source = ./waybar.css;
  };

  # ╔══════════════════════════════════════════════════════════════╗
  # ║  XDG Portals                                               ║
  # ╚══════════════════════════════════════════════════════════════╝
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "wlr" "gtk" ];
    };
  };

  # ╔══════════════════════════════════════════════════════════════╗
  # ║  PAM: swaylock unlock                                      ║
  # ╚══════════════════════════════════════════════════════════════╝
  security.pam.services.swaylock = {};
}
