{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, cairo, pango, systemd
, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "mako-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mako";
    rev = version;
    sha256 = metadata.sha256;
  };
  separateDebugInfo = true;
  mesonBuildType = "debugoptimized";

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs [ scdoc ];
  buildInputs = [ cairo pango systemd wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A lightweight Wayland notification daemon";
    homepage    = "https://wayland.emersion.fr/mako";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
