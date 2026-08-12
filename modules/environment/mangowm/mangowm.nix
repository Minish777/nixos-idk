{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Сам модуль mangowm (программа, порталы, пункт в меню логина)
    inputs.mangowm.nixosModules.mango
    # Дополнительные куски для mango
    ./session.nix
  ];

  # Включаем mangowm как отдельную сессию рядом с Hyprland.
  # Модуль сам добавляет xwayland и порталы (gtk + wlr).
  programs.mango.enable = true;

  # Конфиг mango лежит в ~/.config/mango/*.conf (config.conf подключает
  # env/input/monitors/theme/effects/animations/layout/misc/windowrules/keybinds/autostart).
}
