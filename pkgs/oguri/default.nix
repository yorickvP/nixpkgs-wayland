{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, cairo, gtk3, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "oguri-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "vilhalmer";
    repo = "oguri";
    rev = version;
    sha256 = metadata.sha256;
  };
  separateDebugInfo = true;
  mesonBuildType = "debugoptimized";

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs [ scdoc ];
  buildInputs = [ cairo gtk3 wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A very nice animated wallpaper tool for Wayland compositors";
    homepage    = https://github.com/vilhalmer/oguri;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
