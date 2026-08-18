{ config, lib, pkgs, ... }:

{
  services.zapret2 = {
    enable = true;

    files = [
      "zapret-lib"
      "zapret-antidpi"
    ];

    profiles = {
      # HTTP трафик (порт 80)
      http = {
        priority = 100;
        parameters = [
          "--filter-tcp=80"
          "--filter-l7=http"
          "--out-range=-d10"
          "--payload=http_req"
          "--lua-desync=fake:blob=fake_default_http:ip_autottl=-2,3-20:ip6_autottl=-2,3-20:tcp_md5"
          "--lua-desync=fakedsplit:ip_autottl=-2,3-20:ip6_autottl=-2,3-20:tcp_md5"
        ];
      };

      # HTTPS для Discord/YouTube (с хостлистом)
      https-targeted = {
        priority = 10;
        hosts.include = [
          "discord.com"
          "discord.gg"
          "discordapp.com"
          "discord.media"
          "discordapp.net"
          "discord.dev"
          "discordstatus.com"
          "cdn.discordapp.com"
          "media.discordapp.net"
          "gateway.discord.gg"
          "router.discordapp.net"
          "remote-auth-gateway.discord.gg"
          "youtube.com"
          "www.youtube.com"
          "youtube-ui.l.google.com"
          "wide-youtube.l.google.com"
          "youtubeembedded-pa.googleapis.com"
          "youtube.googleapis.com"
          "jnn-pa.googleapis.com"
          "googlevideo.com"
          "*.googlevideo.com"
          "*.ytimg.com"
          "*.ggpht.com"
        ];
        parameters = [
          "--filter-tcp=443"
          "--filter-l7=tls"
          "--out-range=-d10"
          "--payload=tls_client_hello"
          "--lua-desync=fake:blob=fake_default_tls:tcp_md5:tcp_seq=-10000:tls_mod=rnd,dupsid"
          "--lua-desync=multidisorder:pos=1,midsld"
        ];
      };

      # HTTPS для всего остального (fallback)
      https-fallback = {
        priority = 1000;
        parameters = [
          "--filter-tcp=443"
          "--filter-l7=tls"
          "--out-range=-d10"
          "--payload=tls_client_hello"
          "--lua-desync=fake:blob=fake_default_tls:tcp_md5:tcp_seq=-10000"
          "--lua-desync=multidisorder:pos=midsld"
        ];
      };

      # QUIC для Discord/YouTube (с хостлистом)
      quic-targeted = {
        priority = 10;
        hosts.include = [
          "discord.com"
          "discord.gg"
          "discordapp.com"
          "discord.media"
          "youtube.com"
          "www.youtube.com"
          "googlevideo.com"
          "*.googlevideo.com"
          "jnn-pa.googleapis.com"
        ];
        parameters = [
          "--filter-udp=443"
          "--filter-l7=quic"
          "--payload=quic_initial"
          "--lua-desync=fake:blob=fake_default_quic:repeats=6"
        ];
      };

      # QUIC для всего остального (fallback)
      quic-fallback = {
        priority = 1000;
        parameters = [
          "--filter-udp=443"
          "--filter-l7=quic"
          "--payload=quic_initial"
          "--lua-desync=fake:blob=fake_default_quic:repeats=6"
        ];
      };
    };

    firewall = {
      tcpPorts = [ 80 443 ];
      udpPorts = [ 443 ];
      maxPackets = 16;
    };

    extraOptions = [
      "--debug=0"
    ];
  };

  # Исправляем права доступа — DynamicUser не даёт足够的 прав для nfqueue
  systemd.services."nfqws2@default" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "root";
      ProtectSystem = lib.mkForce "full";
      ProtectHome = lib.mkForce false;
      PrivateDevices = lib.mkForce false;
      SystemCallFilter = lib.mkForce "";
    };
  };
}
