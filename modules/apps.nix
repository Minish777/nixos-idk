{ pkgs, inputs, ... }:

{
  programs.firefox.enable = true;

  # steam
  programs.steam = {
  	enable = true;
  	package = pkgs.millennium-steam;
  	remotePlay.openFirewall = false;
  	dedicatedServer.openFirewall = false;
  };
  
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
    equibop
    davinci-resolve
    rio
    alacritty
	bibata-cursors
	qbittorrent
	openshot-qt
	adwaita-icon-theme
	android-tools
    throne
    micro
    lavat
	git
	yazi
	feh
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
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  nixpkgs.overlays = [ inputs.millennium.overlays.default ];
}
