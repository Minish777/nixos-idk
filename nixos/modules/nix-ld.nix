{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      kdePackages.qtbase
      kdePackages.qttools
      kdePackages.qtwayland
      kdePackages.qtsvg
      kdePackages.qtimageformats
      util-linux
      zlib
      zstd
      mesa
      libGL
      libglvnd
      libxkbcommon
      freetype
      fontconfig
      libx11
      libxext
      libxrandr
      libxrender
      libxcursor
      libxxf86vm
      libxi
      libxcb
      libxfixes
      libxcb-cursor
      libxcb-util
      libxcb-keysyms
      libxcb-wm
      libxcb-image
      libxcb-render-util
      xcb-util-cursor
      glib
      dbus
      krb5
    ];
  };

  # Оставляем включение графики, если его нет в других частях конфига
  hardware.graphics.enable = true;
}
