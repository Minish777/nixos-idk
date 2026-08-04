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

  # Обязательные переменные окружения для корректной работы Hyprland на NVIDIA
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # Отключает аппаратные курсоры (спасает от артефактов на NVIDIA)
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
