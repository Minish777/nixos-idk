{ config, lib, pkgs, ... }:

let
  package = pkgs.zapret2;

  hostlistDiscord = pkgs.writeText "list-discord-youtube.txt" ''
    discord.com
    discord.gg
    discordapp.com
    discord.media
    discordapp.net
    discord.dev
    discordstatus.com
    cdn.discordapp.com
    media.discordapp.net
    gateway.discord.gg
    router.discordapp.net
    remote-auth-gateway.discord.gg
    youtube.com
    www.youtube.com
    youtube-ui.l.google.com
    wide-youtube.l.google.com
    youtubeembedded-pa.googleapis.com
    youtube.googleapis.com
    jnn-pa.googleapis.com
    googlevideo.com
    ytimg.com
    ggpht.com
  '';

  hostlistQuic = pkgs.writeText "list-discord-youtube-quic.txt" ''
    discord.com
    discord.gg
    discordapp.com
    discord.media
    youtube.com
    www.youtube.com
    googlevideo.com
    jnn-pa.googleapis.com
  '';

  luaInits = [
    "--lua-init=@${package}/share/zapret2/lua/zapret-lib.lua"
    "--lua-init=@${package}/share/zapret2/lua/zapret-antidpi.lua"
  ];

  serviceArgs = [
    "--qnum=200"
    "--fwmark=0x40000000"
    "--debug=0"
  ] ++ luaInits ++ [
    "--filter-tcp=80"
    "--filter-l7=http"
    "--out-range=-d10"
    "--payload=http_req"
    "--lua-desync=fake:blob=fake_default_http:ip_autottl=-2,3-20:ip6_autottl=-2,3-20:tcp_md5"
    "--lua-desync=fakedsplit:ip_autottl=-2,3-20:ip6_autottl=-2,3-20:tcp_md5"
    "--new"
    "--hostlist=${hostlistDiscord}"
    "--filter-tcp=443"
    "--filter-l7=tls"
    "--out-range=-d10"
    "--payload=tls_client_hello"
    "--lua-desync=fake:blob=fake_default_tls:tcp_md5:tcp_seq=-10000:tls_mod=rnd,dupsid"
    "--lua-desync=multidisorder:pos=1,midsld"
    "--new"
    "--filter-tcp=443"
    "--filter-l7=tls"
    "--out-range=-d10"
    "--payload=tls_client_hello"
    "--lua-desync=fake:blob=fake_default_tls:tcp_md5:tcp_seq=-10000"
    "--lua-desync=multidisorder:pos=midsld"
    "--new"
    "--hostlist=${hostlistQuic}"
    "--filter-udp=443"
    "--filter-l7=quic"
    "--payload=quic_initial"
    "--lua-desync=fake:blob=fake_default_quic:repeats=6"
    "--new"
    "--filter-udp=443"
    "--filter-l7=quic"
    "--payload=quic_initial"
    "--lua-desync=fake:blob=fake_default_quic:repeats=6"
  ];

in {
  options.services.zapret2-dpi = {
    enable = lib.mkEnableOption "zapret2 DPI bypass for Discord/YouTube";
  };

  config = lib.mkIf config.services.zapret2-dpi.enable {
    environment.systemPackages = [ package ];

    networking.nftables.enable = true;

    networking.nftables.tables.zapret2 = {
      family = "inet";
      content = ''
        define DESYNC_MARK = 0x40000000
        define QNUM = 200
        define PKT = 1-16

        set local4 {
          type ipv4_addr
          flags interval
          elements = {
            127.0.0.0/8,
            10.0.0.0/8,
            100.64.0.0/10,
            172.16.0.0/12,
            192.168.0.0/16,
            169.254.0.0/16
          }
        }

        set local6 {
          type ipv6_addr
          flags interval
          elements = {
            ::1/128,
            fe80::/10,
            fc00::/7,
            ff00::/8
          }
        }

        chain post {
          type filter hook postrouting priority 101; policy accept;
          ip daddr @local4 accept
          ip6 daddr @local6 accept
          meta mark & $DESYNC_MARK == 0 meta l4proto tcp tcp dport { 80, 443 } ct original packets $PKT queue num $QNUM bypass
          meta mark & $DESYNC_MARK == 0 meta l4proto udp udp dport 443 ct original packets $PKT queue num $QNUM bypass
        }

        chain pre {
          type filter hook prerouting priority -101; policy accept;
          ip saddr @local4 accept
          ip6 saddr @local6 accept
          meta mark & $DESYNC_MARK == 0 meta l4proto tcp tcp sport { 80, 443 } ct reply packets $PKT queue num $QNUM bypass
          meta mark & $DESYNC_MARK == 0 meta l4proto udp udp sport 443 ct reply packets $PKT queue num $QNUM bypass
        }

        chain predefrag {
          type filter hook output priority -401; policy accept;
          meta mark & $DESYNC_MARK != 0 notrack
        }
      '';
    };

    systemd.services.zapret2 = {
      description = "zapret2 DPI bypass (Discord + YouTube)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];

      path = [ package ];

      preStart = ''
        sysctl -w net.netfilter.nf_conntrack_tcp_be_liberal=1 2>/dev/null || true
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 5;
        User = "root";
        Group = "root";
        DynamicUser = false;
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
        NoNewPrivileges = false;
        ExecStart = lib.concatStringsSep " " ([ "${package}/bin/nfqws2" ] ++ serviceArgs);
      };
    };

    boot.kernel.sysctl = {
      "net.netfilter.nf_conntrack_tcp_be_liberal" = true;
    };
  };
}
