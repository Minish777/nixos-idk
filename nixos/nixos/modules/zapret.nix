{ config, pkgs, inputs, ... }:

{
  # Подключаем модуль zapret-discord-youtube из flake inputs
  imports = [
    inputs.zapret-discord-youtube.nixosModules.withTestTools
  ];

  # Включаем и настраиваем zapret
  services.zapret-discord-youtube = {
    enable = true;
    # Пресет по умолчанию (при необходимости можно сменить на другой из репозитория)
    configName = "general(ALT11)";
  };
}
