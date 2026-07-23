{ config, pkgs, ... }:

{
hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    open = false;
    nvidiaSettings = true;
  };
}
