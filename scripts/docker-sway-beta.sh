#!/usr/bin/env bash
set -x

result=$(nix-build --no-out-link ../build.nix -A swayContainer)
docker load <"${result}"

tty | grep -q '/dev/tty' || {
  echo "ERROR: Must run from tty/console" >&2
  exit 1
}

[ -z "$XDG_SEAT" ] && echo "WARNING: XDG_SEAT is empty" >&2 && seat=seat0 || seat=$XDG_SEAT
[ -e "/run/systemd/seats/$seat" ] && seat="/run/systemd/seats/$seat" || {
  echo "ERROR: $seat not found" >&2
  exit 1
}

docker run \
  --rm \
  --tty \
  --env XDG_RUNTIME_DIR=/tmp \
  --ipc=host \
  --net=host \
  --pid=host \
  --uts=host \
  --privileged \
  --cap-add ALL \
  --cap-add CAP_SYS_ADMIN \
  --volume=/run:/run \
  --volume=/var/run:/var/run \
    "sway:latest" \
      sway -d
#      mingetty \
#        --autologin "${USER}" \
#        --loginprog "/usr/sway -d"
