{ stdenv, fetchFromGitHub
, meson, ninja
, pkgconfig, scdoc
, wayland, libevdev, libxkbcommon, pcre, json_c, dbus
, pango, cairo, libinput, libcap, gdk_pixbuf
, wlroots, wayland-protocols
, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    wayland libevdev libxkbcommon pcre json_c dbus
    pango cairo libinput libcap gdk_pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Dsway-version=${version}"
    "-Ddefault-wallpaper=false"
    "-Dxwayland=enabled"
    "-Dtray=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];
  separateDebugInfo = true;
  mesonBuildType = "debugoptimized";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
