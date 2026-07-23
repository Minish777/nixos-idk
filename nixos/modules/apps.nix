{ pkgs, inputs, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
	bibata-cursors
	adwaita-icon-theme
    throne
    micro
	git
	curl
	fastfetch
	fish
	starship
	hyprland
	kitty
	foot
	nautilus
	spotify
	flatpak
	goofcord
	prismlauncher
	cava
	unzip
	unrar
	eza
	bat
	btop
	materialgram
	protonplus
	obs-studio
	inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
