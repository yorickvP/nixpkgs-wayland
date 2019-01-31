{ stdenv, fetchFromGitHub
, meson, ninja
, pkgconfig, scdoc
, wayland, wayland-protocols
, libxkbcommon, cairo, pango, gdk_pixbuf, pam
, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "swaylock";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    wayland wayland-protocols
    libxkbcommon cairo pango gdk_pixbuf pam
  ];

  mesonFlags = [
    "-Dswaylock-version=${version}"
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];
  separateDebugInfo = true;
  mesonBuildType = "debugoptimized";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Screen locker for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
