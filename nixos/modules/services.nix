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
	  
	# cpupower performance
	powerManagement.cpuFreqGovernor = "performance";

  # Включаем поддержку Flatpak на системном уровне
  services.flatpak.enable = true;
}
