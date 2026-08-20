{ pkgs, inputs, ... }:

{
  # Системные службы, необходимые для виджетов Noctalia (звук, Bluetooth, питание)
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Установка самого пакета Noctalia шелла в системный профиль напрямую из флейка
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
