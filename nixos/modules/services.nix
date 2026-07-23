{ pkgs, ... }:

{
  # Сеть
  networking.networkmanager.enable = true;

  # Печать
  services.printing.enable = true;

  # Звук (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Настройка утилиты Throne (из твоего старого конфига)
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
	# proxy
services.mtprotoproxy = {
    enable = true;
    port = 1443;
    users = {
      # Задаем имя пользователя (например, "proxy") и его секретный хекс-ключ
      proxy = "9cca40f9f9e44e35bb44202aa0e8b812";
    };
  };
	  
	# cpupower performance
	powerManagement.cpuFreqGovernor = "performance";

  # Включаем поддержку Flatpak на системном уровне
  services.flatpak.enable = true;
}
