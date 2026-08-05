{ pkgs, ... }:

{
  # Включаем сам Hyprland на уровне NixOS и активируем Xwayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.glaze ];
    });
  };

  # Порталы: нужны для шаринга экрана в Discord и других приложениях.
  # Модуль programs.hyprland уже сам добавляет xdg-desktop-portal-hyprland
  # в extraPortals, поэтому здесь только gtk (иначе пакет дублируется
  # и падает сборка: "xdg-desktop-portal-hyprland.service: File exists")
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # xdg-desktop-portal.service не стартует, пока не активен graphical-session.target,
  # а тот запрещает ручной запуск. Стартуем его через обёртку из autostart.lua:
  #   systemctl --user start hyprland-session.target
  systemd.user.targets.hyprland-session = {
    description = "Hyprland session target";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };

  # Обязательные переменные окружения для корректной работы Hyprland на NVIDIA
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # Отключает аппаратные курсоры (спасает от артефактов на NVIDIA)
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
