{
  description = "Steelium NixOS Flake Configuration";

  inputs = {
    # Актуальный нестабильный канал NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # tg-ws-proxy
    tg-ws-proxy.url = "path:/etc/nixos/flakes/tg-ws-proxy";

    # Репозиторий ядра CachyOS
    cachyos = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Шелл Noctalia (без указания несуществующих веток/тегов)
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Добавлен zapret для Discord и YouTube
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";

    # spicetify
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    
    # Zen Browser флок
        zen-browser = {
          url = "github:0xc000022070/zen-browser-flake";
          inputs.nixpkgs.follows = "nixpkgs";
    		};
  };

  outputs = { self, nixpkgs, cachyos, noctalia, zen-browser, spicetify-nix, tg-ws-proxy, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./modules/spicetify.nix
          spicetify-nix.nixosModules.spicetify
          tg-ws-proxy.nixosModules.default
        ];
      };
    };
  };
}

