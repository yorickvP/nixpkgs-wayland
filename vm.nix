{  }:

let
  nixpkgs = (import ./nixpkgs);
  pkgs = import nixpkgs {
    overlays = [ (import ./default.nix) ];
  };
in
{
  import "${pkgs}/nixos/lib/make-disk-image.nix" rec {
    name = "nixos-wayland-${config.system.nixosLabel}";

    config = machine.config;
  }
}

