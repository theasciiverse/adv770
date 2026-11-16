# Adventure 770

Mike Arnautov's 770-point Adventure: the Colossal Cave, grown to 478
places and 41 treasures to score in full. Gather them, outwit the dwarves,
and examine almost anything the game mentions.

## Play

With [av](https://asciiverse.sh), the Asciiverse client:

```
av install adv770
av play adv770
```

Saved games, the config file and the game you were in the middle of are
kept in `$XDG_STATE_HOME/adv770` (usually `~/.local/state/adv770`), or
`%LOCALAPPDATA%\adv770` on Windows. Start with `-n` to begin a new game
instead of picking up where you left off. Set `ADV770_LOG=1` to keep a log
of the session in `adv770.log` there.

## Credits

Will Crowther wrote Adventure in 1976 and expanded it with Don Woods in
1977; Dave Platt's Adventure 3 (Adv550, 1984) and Peter Luckett and Jack
Pike's Adventure II (Adv440, 1979) grew from it, and Mike Arnautov combined
them in 1985 into what became Adv660, then expanded that into Adv770,
released in March 2003 (https://mipmip.org/adv770/). GPL-3.0-or-later
(LICENCE, COPYING).

This is the console build for the Asciiverse catalog; what changed is in
PATCHES.md. The game's own README, unchanged, is `README`, and its A-code
sources and the A-code system are in this repository as Mike Arnautov
released them.
