{ config, pkgs, lib, ... }:

{
  # Включаем сам Hyprland на уровне NixOS и активируем Xwayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Порталы: нужны для шаринга экрана в Discord и других приложениях.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # xdg-desktop-portal.service не стартует, пока не активен graphical-session.target
  systemd.user.targets.hyprland-session = {
    description = "Hyprland session target";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };

  # Обязательные переменные окружения для корректной работы Hyprland на NVIDIA.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1";
  };
}
