{ inputs, ... }: {
  imports = [
    inputs.zapret-discord-youtube.nixosModules.withTestTools
  ];

  services.zapret-discord-youtube = {
    enable = true;
    configName = "general(ALT10)";
    gameFilter = "null";
  };
}
