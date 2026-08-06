{
  description = "lyricspot - good old live synced lyrics in ur terminal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    mkLyricspot = pkgs:
      pkgs.stdenv.mkDerivation {
        pname = "lyricspot";
        version = "unstable-2026-05-30";

        src = pkgs.fetchFromGitHub {
          owner = "vlensys";
          repo = "lyricspot";
          rev = "28a3a76477313117acce866ee9ead070d06011c6";
          hash = "sha256-5YEEZdWL9hVQquEYFu476u/QZJV6KQ3CV0rFBKrQqYE=";
        };

        dontBuild = true;

        nativeBuildInputs = [ pkgs.python3 ];

        installPhase = ''
          runHook preInstall
          install -Dm755 lyricspot.py $out/bin/lyricspot
          patchShebangs $out/bin/lyricspot
          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "good old live synced lyrics in your terminal";
          homepage = "https://github.com/vlensys/lyricspot";
          license = licenses.gpl3Plus;
          platforms = platforms.linux;
          mainProgram = "lyricspot";
        };
      };
  in
  {
    packages.${system} = {
      default = mkLyricspot pkgs;
    };

    # Добавляет сам lyricspot и playerctl (нужен для получения трека из MPRIS)
    nixosModules.default = { pkgs, ... }: {
      environment.systemPackages = [
        pkgs.playerctl
        (mkLyricspot pkgs)
      ];
    };
  };
}
