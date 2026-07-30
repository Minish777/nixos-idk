{ pkgs, inputs, ... }:

{
  programs.firefox.enable = true;

  programs.obs-studio = {
    enable = true;
  
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-system-monitor
    wineWow64Packages.full
    winetricks
    pywalfox-native
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
	foot
	nautilus
	spotify
	flatpak
	goofcord
	prismlauncher
	cava
	unzip
	nftables
	iproute2
	unrar
	eza
	bat
	btop
	materialgram
	protonplus
	ffmpeg
	inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
