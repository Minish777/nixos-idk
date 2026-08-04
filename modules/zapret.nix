{ inputs, ... }: {
  imports = [
    inputs.zapret-discord-youtube.nixosModules.withTestTools
  ];

  services.zapret-discord-youtube = {
    enable = true;
    # "general(ALT11)" + обход Cloudflare для Minecraft (порт 25565)
    configName = "general(ALT11)-minecraft";
    gameFilter = "null";

    extraConfigs."general(ALT11)-minecraft" = ''
      # Производная от general(ALT11): берём базовый конфиг и добавляем
      # стратегию для Minecraft (TCP 25565), которой DPI режет соединение после 16 КБ.
      . "/opt/zapret/configs/general(ALT11)"

      NFQWS_PORTS_TCP="$NFQWS_PORTS_TCP,25565"

      NFQWS_OPT="$NFQWS_OPT
      --filter-tcp=25565 --ipset-exclude="/opt/zapret/hostlists/ipset-exclude.txt" --dpi-desync-any-protocol=1 --dpi-desync-cutoff=n5 --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=654 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="/opt/zapret/files/fake/tls_clienthello_max_ru.bin" --dpi-desync-fake-tls="/opt/zapret/files/fake/tls_clienthello_max_ru.bin" --new
      --filter-tcp=25565 --ipset-exclude="/opt/zapret/hostlists/ipset-exclude.txt" --dpi-desync-any-protocol=1 --dpi-desync-cutoff=n5 --dpi-desync=multisplit --dpi-desync-split-seqovl=582 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern="/opt/zapret/files/fake/tls_clienthello_4pda_to.bin" --new
      "
    '';
  };
}
