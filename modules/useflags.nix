{ config, lib, pkgs, ... }:

# ╔══════════════════════════════════════════════════════════════════╗
# ║  useflags.nix — Gentoo-style USE-flags для NixOS               ║
# ║  Только то, чего НЕТ в других модулях                          ║
# ║  Hardware: Xeon E5-2680 v4 (x86-64-v3), 32GB, GTX 1050       ║
# ╚══════════════════════════════════════════════════════════════════╝
{

  # ── 1. Nix daemon: параллельная сборка ──────────────────────────
  # (sandbox уже true по умолчанию, max-jobs/cores нигде не заданы)
  nix.settings = {
    max-jobs = "auto";   # Все 28 потоков Xeon
    cores = 0;           # Каждый джоб берёт все свободные ядра
  };

  # ── 2. Оверрайды пакетов (USE-flags) ───────────────────────────
  nixpkgs.overlays = [

    # ┌─────────────────────────────────────────────────────────────┐
    # │ ffmpeg: полная сборка (дефолт — small, не хватает кодеков)  │
    # └─────────────────────────────────────────────────────────────┘
    (final: prev: {
      ffmpeg = prev.ffmpeg.override {
        ffmpegVariant = "full";
        # NVIDIA NVENC/NVDEC/CUDA (GTX 1050)
        withNvcodec = true;
        withNvenc = true;
        withNvdec = true;
        withCuda = true;
        # Intel QSV (на будущее)
        withVpl = true;
        # Видео кодеки
        withX264 = true;
        withX265 = true;
        withVpx = true;
        withDav1d = true;       # AV1 декодер
        withSvtav1 = true;      # AV1 кодер
        withTheora = true;
        # Аудио кодеки
        withFdkAac = true;      # Fraunhofer AAC (лучший)
        withMp3lame = true;
        withOpus = true;
        withVorbis = true;
        # API/аппаратное
        withVaapi = true;
        withVulkan = true;
        withSrt = true;         # Secure Reliable Transport
        withSsh = true;         # SFTP
        withRist = true;
        # Лицензия
        withGPL = true;
        withUnfree = true;      # FDK AAC + CUDA
      };
    })

    # ┌─────────────────────────────────────────────────────────────┐
    # │ mpv: максимум декодирования и вывода                       │
    # └─────────────────────────────────────────────────────────────┘
    (final: prev: {
      mpv = prev.mpv.override {
        mpv-unwrapped = prev.mpv-unwrapped.override {
          # Аппаратное ускорение
          vaapiSupport = true;
          vdpauSupport = true;
          vulkanSupport = true;
          # Вывод (waylandSupport уже true по умолчанию на Linux)
          drmSupport = true;
          # Аудио
          pipewireSupport = true;
          pulseSupport = true;
          alsaSupport = true;
          jackaudioSupport = true;
          openalSupport = true;
          # Фичи
          archiveSupport = true;
          bluraySupport = true;
          bs2bSupport = true;
          cacaSupport = true;
          cmsSupport = true;
          dvdnavSupport = true;
          javascriptSupport = true;
          rubberbandSupport = true;
          zimgSupport = true;
          dvbinSupport = true;
          # Выключаем ненужное
          sixelSupport = false;
          sdl2Support = false;
          cddaSupport = false;
        };
      };
    })

    # ┌─────────────────────────────────────────────────────────────┐
    # │ OBS: CUDA + PipeWire + Decklink + FDK AAC                  │
    # └─────────────────────────────────────────────────────────────┘
    (final: prev: {
      obs-studio = prev.obs-studio.override {
        cudaSupport = true;        # nv-编码
        pipewireSupport = true;    # захват окон Wayland
        alsaSupport = true;
        pulseaudioSupport = true;
        scriptingSupport = true;   # Lua/Python скрипты
        decklinkSupport = true;    # Blackmagic устройства
        withFdk = true;            # FDK AAC кодек
      };
    })

    # ┌─────────────────────────────────────────────────────────────┐
    # │ Wine: максимум поддержки Windows-приложений                │
    # └─────────────────────────────────────────────────────────────┘
    (final: prev: {
      wineWow64Packages = prev.wineWow64Packages // {
        full = prev.wineWow64Packages.full.override {
          alsaSupport = true;
          cupsSupport = true;
          fontconfigSupport = true;
          gstreamerSupport = true;
          gtkSupport = true;
          pulseaudioSupport = true;
          tlsSupport = true;
          v4lSupport = true;
          xineramaSupport = true;
        };
      };
    })

    # ┌─────────────────────────────────────────────────────────────┐
    # │ PipeWire: поддержка камер                                   │
    # └─────────────────────────────────────────────────────────────┘
    (final: prev: {
      pipewire = prev.pipewire.override {
        libcameraSupport = true;
      };
    })
  ];

  # ── 3. sysctl: тюнинг ядра (не задано ни в одном другом модуле) ─
  boot.kernel.sysctl = {
    # Сеть
    "net.core.somaxconn" = 1024;
    "net.core.netdev_max_backlog" = 5000;
    "net.ipv4.tcp_max_syn_backlog" = 1024;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_fin_timeout" = 15;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;

    # Память
    "vm.swappiness" = 10;          # Меньше свопа (32GB RAM хватает)
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;

    # Планировщик ( понижает input lag в играх )
    "kernel.sched_autogroup_enabled" = 0;
    "kernel.sched_migration_cost_ns" = 5000000;
    "kernel.timer_migration" = 0;

    # Файловая система
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
  };

  # ── 4. Диагностика железа (не установлено в apps.nix) ──────────
  environment.systemPackages = with pkgs; [
    libva-utils          # vainfo — проверка VA-API
    vdpauinfo            # проверка VDPAU
    vulkan-tools         # vulkaninfo
    mesa-demos           # glxinfo, eglinfo
    cpupower             # управление процессором
    intel-gpu-tools      # мониторинг Intel GPU
    lshw                 # полная инфа о железе
    hwloc                # топология CPU/GPU
    lm_sensors           # датчики температуры

    # Сборочные инструменты (для локальной компиляции в nix-shell)
    cmake
    ninja
    pkg-config
    autoconf
    automake
    libtool
  ];

  # ── 5. Compiler flags (только уникальные, не в hyprland.nix) ────
  environment.sessionVariables = {
    # GPU: NVIDIA VDPAU (LIBVA_DRIVER_NAME уже в hyprland.nix)
    VDPAU_DRIVER = "nvidia";

    # Wayland: только то, чего НЕТ в hyprland.nix
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";

    # Параллельная сборка
    MAKEFLAGS = "-j28";

    # Оптимизации памяти
    MALLOC_TRIM_THRESHOLD_ = "65536";
    MALLOC_MMAP_THRESHOLD_ = "65536";

    # Compiler flags для локальной компиляции в nix-shell
    NIX_CFLAGS_COMPILE = "-march=x86-64-v3 -O2 -pipe";
    NIX_LDFLAGS = "-Wl,-O1 -Wl,--as-needed";
  };
}
