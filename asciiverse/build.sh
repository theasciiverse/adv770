#!/bin/sh
# Builds Adv770 into out/ from the game's ready-made C sources
# (adv770-2.33/C), console only: -DCONSOLE leaves out the browser display
# and its local web server, so the game never opens a browser or a socket.
# The compiler, flags and line editing come from the environment, so one
# script serves every target (see .github/workflows/release.yml):
#
#   asciiverse/build.sh                                         # Linux, readline
#   LDFLAGS="-static -s" LIBS="-lreadline -lncursesw" asciiverse/build.sh   # Alpine, static
#   LIBS=-lreadline asciiverse/build.sh                         # macOS, the system's libedit
#   CC=x86_64-w64-mingw32-gcc CFLAGS="-O2 -DNO_READLINE" LIBS= \
#     LDFLAGS="-static -s" EXE=.exe asciiverse/build.sh         # Windows
set -eu
cd "$(dirname "$0")/.."
CC="${CC:-cc}"
CFLAGS="${CFLAGS:--O2}"
LDFLAGS="${LDFLAGS:-}"
LIBS="${LIBS--lreadline}"
EXE="${EXE:-}"
mkdir -p out
# shellcheck disable=SC2086
$CC $CFLAGS -DCONSOLE -o "out/adv770$EXE" adv770-2.33/C/*.c $LDFLAGS $LIBS
echo "built adv770$EXE"
