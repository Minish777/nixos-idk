{ pkgs, inputs, ... }:

{
  programs.firefox.enable = true;
programs.appimage = {
  enable = true;
  binfmt = true;
  package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [ pkgs.icu ];
  };
};

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
	qbittorrent
	adwaita-icon-theme
    throne
    micro
	git
	curl
	kitty
	fastfetch
	fish
	starship
	foot
	nautilus
	spotify
	flatpak
	goofcord
	prismlauncher
	cava
	blockbench
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
	vlc
	inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
