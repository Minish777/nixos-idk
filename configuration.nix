{ config, pkgs, ... }:

{
  imports = [
    # Системное железо после установки
    ./hardware-configuration.nix

    # Твои кастомные модули
    ./modules/hardware/nvidia.nix
    ./modules/hardware/kernel.nix
    ./modules/environment/hyprland.nix
    ./modules/environment/mangowm/mangowm.nix
    ./modules/environment/noctalia.nix
    ./modules/apps.nix
    ./modules/services.nix
    { services.zapret-discord-youtube.enable = true; }
    ./modules/fonts.nix
    ./modules/autostart.nix
    ./modules/nix-ld.nix
  ];

  # Загрузчик
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77845DC4D0";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";

  # Часовой пояс и локаль
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Раскладка клавиатуры в X11 (нужна для подстраховки Xwayland)
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle"; # Переключение по Alt + Shift (можешь поменять на "grp:caps_toggle" если хочешь по Caps Lock)
  };

  # services.xserver.enable = true;
    services.displayManager.ly.enable = true;

  # gamemode
  programs.gamemode.enable = true;
  
  # Пользователь
  users.users."steelium" = {
    isNormalUser = true;
    description = "steelium";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "keyring" ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };

	 
	  #steam
	  programs.steam = {
	    enable = true;
	    remotePlay.openFirewall = false;
	    dedicatedServer.openFirewall = false; 
	  };

	  # HDD
		fileSystems."/home/steelium/Games" = {
    device = "/dev/disk/by-uuid/99508f19-4d8a-4875-877a-7e0cd0f59cdd";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  # fish shell
  programs.fish.enable = true;

  # Разрешаем нераспространяемые пакеты (нужно для драйверов NVIDIA и т.д.)
  nixpkgs.config.allowUnfree = true;

  # Hyprland 0.56.x требует glaze 7...<8, а в unstable уже 8.0.0 — пиним 7.9.1
  nixpkgs.overlays = [
    (final: prev: {
      glaze = prev.glaze.overrideAttrs (old: {
        version = "7.9.1";
        src = prev.fetchFromGitHub {
          owner = "stephenberry";
          repo = "glaze";
          tag = "v7.9.1";
          hash = "sha256-NRRq5MGF2f5PW0teYnq58ELzson+U6KHVPaY6r30KLA=";
        };
      });
    })
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  zramSwap.enable = true;

# Автоматическая сборка мусора (оставляем только последние 3 дня)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  # Автоматическая оптимизация хранилища (дедупликация)
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "26.05";
}
