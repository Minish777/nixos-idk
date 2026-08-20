{ config, lib, pkgs, ... }:

# ╔══════════════════════════════════════════════════════════════════╗
# ║  useflags.nix — системные оптимизации под железо               ║
# ║  Xeon E5-2680 v4 (x86-64-v3) · 32GB · GTX 1050               ║
# ╚══════════════════════════════════════════════════════════════════╝
{

  # ── Сборка: все 28 потоков Xeon ─────────────────────────────────
  nix.settings = {
    max-jobs = "auto";
    cores = 0;
  };

  # ── sysctl: тюнинг ядра под железо ─────────────────────────────
  boot.kernel.sysctl = {
    # Сеть
    "net.core.somaxconn" = 1024;
    "net.core.netdev_max_backlog" = 5000;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_fin_timeout" = 15;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;

    # Память
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;

    # Планировщик (нижет input lag)
    "kernel.sched_autogroup_enabled" = 0;

    # Файловая система
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
  };

  # ── Compiler flags для локальной сборки (nix-shell) ─────────────
  environment.sessionVariables = {
    NIX_CFLAGS_COMPILE = "-march=x86-64-v3 -O2 -pipe";
    NIX_LDFLAGS = "-Wl,-O1 -Wl,--as-needed";
    MAKEFLAGS = "-j28";
  };
}
