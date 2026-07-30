{ pkgs, ... }:

let
  dwlCustom = (pkgs.dwl.override {
    configH = ./config.h;
  }).overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/vanitygaps/vanitygaps-0.8.patch";
        hash = "sha256-ukSTVHnZxetD1UyLO108U7TjlNjxYVZFHgOOHTIrKa8=";
      })
      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/attachbottom/attachbottom.patch";
        hash = "sha256-t46gsJLpdcSwRo9d+nlzm+QWOeDEFxFNbQSd03yxHbY=";
      })
      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/autostart/autostart-0.8.patch";
        hash = "sha256-ozrEKocN9aNLlBOY0uPYdilEzZRR7VAkWZqLkxEOpAw=";
      })
      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/movestack/movestack-0.8.patch";
        hash = "sha256-3nBQZHsfmS9GWAT9EzyKKhMZT0J4vFGXE7aJ2DeebFk=";
      })
    ];
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -Wno-error=incompatible-pointer-types";
  });
in
{
  programs.dwl = {
    enable = true;
    package = dwlCustom;
    extraSessionCommands = ''
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1
      export XKB_DEFAULT_LAYOUT=us,ru
      export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
      export XCURSOR_THEME=Bibata-Modern-Classic
      export XCURSOR_SIZE=24
    '';
  };
}
