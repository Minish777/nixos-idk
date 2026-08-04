{
  description = "Proxy Suite & Zapret module";

  inputs = {
    proxy-suite.url = "github:FUFSoB/proxy-suite-flake";
  };

  outputs = { self, proxy-suite, ... }: {
    nixosModules.default = { config, lib, pkgs, ... }: {
      imports = [ proxy-suite.nixosModules.default ];

      services.proxy-suite = {
        enable = true;
        # perAppRouting.enable = true; # Можно выключить, если больше нигде не используется

        tray = {
          enable = true;
          autostart = true;
        };

        tgWsProxy = {
          enable = true;
          port = 1443;
          secret = "be92900c81afe6a83aa2285c2d0ec1b3";
        };
      };
    };
  };
}
