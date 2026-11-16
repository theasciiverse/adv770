# Changes from upstream

This is the Asciiverse packaging of Adv770, Mike Arnautov's 770-point
version of Adventure, first released in March 2003. Upstream has no
repository: the first commit here is his source release
`adv770-2.33-src.tgz` from https://mipmip.org/adv770/ (version 2.33,
2026-07-26; 2334633 bytes, sha256
`44067d9d91a087e17d755fa6081fba521430f6d3eb55c4b13dd55274db791cfb`), with
the tarball's top folder as the repository root, tagged `2.33`. Releases
are tagged `v2.33-av.N`. The `asciiverse` branch carries the changes below,
one commit each.

Licence: GPL-3.0-or-later (`LICENCE`, the package's own notice; `COPYING`,
the licence text, added here).

## The game

Unchanged: the A-code sources (`adv770-2.33/*.acd`) and the C translated
from them (`adv770-2.33/C/adv02.c` to `adv05.c`, `adv1.h` to `adv6.h`), so
the same cave, treasures, texts, scoring and save penalties. Only the A-code
kernel copy that is built, `adv770-2.33/C/adv00.c`, changes; the identical
copy in `acode-12.92/kernel-12.92/` is left as released.

## Ours

- **Console only.** Built with `-DCONSOLE` (a build option the kernel
  already has), so the browser display and the local web server behind it
  are left out: the game plays in the terminal it is started in and never
  opens a browser or a socket. No code change.
- **Config, saves and the resume state in the player's state folder.**
  The game kept `acode.conf` in `~/.acode` and its saved games, the state
  of an interrupted game and its log in `~/.acode/adv770` (`HOMEPATH` on
  Windows). They now all live in `$XDG_STATE_HOME/adv770`, else
  `~/.local/state/adv770` (Linux and macOS), or `%LOCALAPPDATA%\adv770` on
  Windows, made with its parents as needed. A config file beside the
  executable is still read first. `adv00.c` (`read_conf()`, `gothere()`),
  and a new `adv770-2.33/C/asciiverse.c` that names the folder, kept apart
  from the kernel so `windows.h` never meets its names.
- **Text laid out to the terminal's size.** The console assumed 80x24
  unless told otherwise. With no size from `-s` or the config file it now
  takes the terminal's width and height, and 80x24 only when they cannot
  be read; the margin shrinks if fewer than 16 columns of text would be
  left, and the readline prompt buffer follows the width. The config file
  written at first start has its `LAYOUT WIDTH` and `HEIGHT` lines
  commented out, saying so. `adv00.c` (`read_conf()`, the config
  template), `asciiverse.c` (`av_term_size()`).
- **Session log behind `ADV770_LOG`.** Set it to anything and the game's
  own log (as with `-l`) goes to `adv770.log` in the state folder: each
  session's start, every command as typed, every answer to a question or a
  `[More?]`, and every reply, appended. Without it nothing is written.
  `adv00.c` (`parse_args()`).
- **A README.md** on playing it with av; the game's own `README` is
  unchanged.

## Packaging (new files)

- `asciiverse/build.sh`: builds `out/adv770` from `adv770-2.33/C/*.c`
  with `-DCONSOLE`; the compiler, flags and line editing come from the
  environment. Linux: static, in Alpine 3.22, with readline 8.2.13 and
  ncurses 6.5 linked in. macOS: the system's readline (libedit) only.
  Windows: MinGW-w64, `-DNO_READLINE`, the console's own line editing.
- `asciiverse/package.sh`: lays out each av archive (the binary, README.md,
  PATCHES.md, LICENCE, COPYING, the game's README as `README.adv770`, and on
  Linux `licenses/` for the libraries linked in).
- `asciiverse/licenses/ncurses.txt`: ncurses' licence (MIT-style), from
  6.5-20250503, the version in Alpine 3.22. readline is GPL-3.0-or-later,
  covered by COPYING.
- `asciiverse/adv770.cast` and `asciiverse/record-preview.py`: the catalog
  preview and the script that records it.
- `.github/workflows/release.yml`: builds all of it on a tag.
- `.gitignore`: build output of the above.

## Not built or not shipped

- The browser display, the HTML/JavaScript, Qt and CGI builds.
- `extras/adv770.desktop` and the icons: Asciiverse packages add no menu
  entries.
- The A-code to C translator (`acode-12.92/acdc-12.49`): the C sources come
  ready-made in the release.
