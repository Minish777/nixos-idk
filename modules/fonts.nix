{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      departure-mono
(pkgs.runCommand "varela-round-font" {} ''
        mkdir -p $out/share/fonts/truetype
        cp -t $out/share/fonts/truetype/ ${../fonts/Varela_Round}/*.*
      '')
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
    };
  };
}
