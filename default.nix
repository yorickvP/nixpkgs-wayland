self: pkgs:
let
  inherit (self) wayland-debug;
waylandPkgs = {
  # temp
  wlroots-old      = pkgs.callPackage ./pkgs-temp/wlroots { wayland = wayland-debug; };
  scdoc-1_8        = pkgs.callPackage ./pkgs-temp/scdoc {};

  # wlroots-related
  wlroots          = pkgs.callPackage ./pkgs/wlroots { wayland = wayland-debug; };
  sway-beta        = pkgs.callPackage ./pkgs/sway-beta { scdoc = self.scdoc-1_8; wayland = wayland-debug; };
  swayidle         = pkgs.callPackage ./pkgs/swayidle { wayland = wayland-debug; };
  swaylock         = pkgs.callPackage ./pkgs/swaylock { wayland = wayland-debug; };
  grim             = pkgs.callPackage ./pkgs/grim { wayland = wayland-debug; };
  slurp            = pkgs.callPackage ./pkgs/slurp { wayland = wayland-debug; };
  mako             = pkgs.callPackage ./pkgs/mako { wayland = wayland-debug; };
  kanshi           = pkgs.callPackage ./pkgs/kanshi {};
  wlstream         = pkgs.callPackage ./pkgs/wlstream { wayland = wayland-debug; };
  oguri            = pkgs.callPackage ./pkgs/oguri { wayland = wayland-debug; };
  waybar           = pkgs.callPackage ./pkgs/waybar { wayland = wayland-debug; };
  wf-config        = pkgs.callPackage ./pkgs/wf-config {};
  wayfire          = pkgs.callPackage ./pkgs/wayfire { wlroots = self.wlroots-old; wayland = wayland-debug; };
  redshift-wayland = pkgs.callPackage ./pkgs/redshift-wayland {
    inherit (self.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = self.geoclue2;
   wayland = wayland-debug; };
  bspwc            = pkgs.callPackage ./pkgs/bspwc { wayland = wayland-debug; };
  waybox           = pkgs.callPackage ./pkgs/waybox { wayland = wayland-debug; };
  wl-clipboard     = pkgs.callPackage ./pkgs/wl-clipboard { wayland = wayland-debug; };

  # i3-related
  wmfocus          = pkgs.callPackage ./pkgs/wmfocus { };
  i3status-rust    = pkgs.callPackage ./pkgs/i3status-rust {};
  wayland-debug    = pkgs.wayland.overrideAttrs (old: {
    NIX_CFLAGS_COMPILE = "-g";
    separateDebugInfo = true;
  });
};
in
  waylandPkgs // { inherit waylandPkgs; }

