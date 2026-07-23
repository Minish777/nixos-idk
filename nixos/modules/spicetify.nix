{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs.spicetify = {
    enable = true;
    
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];

    # Используем стандартную тему из набора пакетов spicetify-nix
    theme = spicePkgs.themes.default;
  };
}
