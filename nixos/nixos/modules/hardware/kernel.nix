{ pkgs, inputs, ... }:

{
  # Подключаем оверлей репозитория CachyOS
  nixpkgs.overlays = [
    inputs.cachyos.overlays.default
  ];

  # Бинарный кэш от автора репозитория (для v3 он есть, скачается готовым)
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  # Указываем конкретную версию ядро: BORE планировщик + оптимизация x86-64-v3
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;

  # Производительный губернатор
  powerManagement.cpuFreqGovernor = "performance";
}
