#!/bin/sh
# Packs the build into dist/adv770-<target>.tar.gz (.zip for Windows) for
# av: the binary at the top beside README.md, PATCHES.md, the game's own
# README and LICENCE, and the licences of the libraries linked in.
#
#   asciiverse/package.sh x86_64-unknown-linux-musl
set -eu
cd "$(dirname "$0")/.."
target="$1"
case "$target" in *windows*) exe=.exe ;; *) exe= ;; esac
stage=stage/adv770
rm -rf "$stage" && mkdir -p "$stage" dist
cp "out/adv770$exe" README.md PATCHES.md LICENCE COPYING "$stage/"
cp adv770-2.33/README "$stage/README.adv770"
case "$target" in
  *linux-musl) mkdir -p "$stage/licenses"; cp asciiverse/licenses/* "$stage/licenses/" ;;
esac
if [ -n "$exe" ]; then
  (cd "$stage" && zip -qr "../../dist/adv770-$target.zip" .)
else
  tar -czf "dist/adv770-$target.tar.gz" -C "$stage" .
fi
ls dist
