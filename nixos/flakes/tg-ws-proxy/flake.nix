{
  description = "TG WS Proxy module";

  inputs = {
    proxy-suite.url = "github:FUFSoB/proxy-suite-flake";
  };

  outputs = { self, proxy-suite, ... }: {
    nixosModules.default = { pkgs, ... }: {
      # Подключаем сам модуль proxy-suite
      imports = [ proxy-suite.nixosModules.default ];

      services.proxy-suite = {
        enable = true;

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
