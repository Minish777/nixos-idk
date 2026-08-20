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
        perAppRouting.enable = true; # Можно выключить, если больше нигде не используется

        zapret = {
          enable = true;
          perApp.enable = true;
        };

        tray = {
          enable = true;
          autostart = true;
        };

        tgWsProxy = {
          enable = true;
          port = 1443;
          # Секрет лежит вне git: /etc/nixos/secrets/ (в .gitignore)
          secretFile = "/etc/nixos/secrets/tg-ws-proxy-secret";
        };
      };
    };
  };
}
