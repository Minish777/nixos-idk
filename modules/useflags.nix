{ config, lib, pkgs, ... }:

# ╔══════════════════════════════════════════════════════════════════╗
# ║  useflags.nix — Gentoo-style USE-flags для NixOS               ║
# ╚══════════════════════════════════════════════════════════════════╝
{

  nix.settings = {
    max-jobs = "auto";
    cores = 0;
  };
}
