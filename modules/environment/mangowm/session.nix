{ ... }:

{
  # xdg-desktop-portal не стартует, пока не активен graphical-session.target,
  # а тот запрещает ручной запуск. Поэтому стартуем обёртку mango-session.target
  # из ~/.config/mango/autostart.conf:
  #   systemctl --user start mango-session.target
  systemd.user.targets.mango-session = {
    description = "mango session target";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };
}
