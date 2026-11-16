#!/usr/bin/env python3
"""Records asciiverse/adv770.cast, the catalog preview, at 100x30
(hub/RECORDING.md): the opening in the grey nowhere, then into the well
house, down the valley and through the grate, typed at a human pace, with
a throwaway HOME so a fresh game starts. Run after a Linux build:
    python3 asciiverse/record-preview.py"""
import fcntl, json, os, pty, select, shutil, struct, sys, tempfile, termios, time

MOVES = ["contemplate", "no", "east", "read poster", "get lamp and keys", "out",
         "south", "south", "south", "unlock grate", "down", "light lamp", "west"]

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
cast = f"{root}/asciiverse/adv770.cast"
home = tempfile.mkdtemp()
env = dict(os.environ, HOME=home, TERM="xterm-256color", LANG="C.UTF-8")
env.pop("XDG_STATE_HOME", None)

pid, fd = pty.fork()
if pid == 0:
    os.execvpe("asciinema", ["asciinema", "rec", "--overwrite", "-q", "-i", "2",
        "--capture-env", "TERM,LANG", "-c", f"{root}/out/adv770", cast], env)
fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 30, 100, 0, 0))

def pump(t):
    end = time.time() + t
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.03)
        if r:
            try: os.read(fd, 65536)
            except OSError: return

def type_line(line, after=2.6):
    for c in line:
        os.write(fd, c.encode()); pump(0.09)
    os.write(fd, b"\r"); pump(after)

pump(6.0)                       # time to read the opening
for move in MOVES:
    type_line(move, 4.0 if move in ("contemplate", "read poster", "down") else 2.6)
type_line("quit", 1.2)
type_line("yes", 3.0)
for _ in range(50):
    if os.waitpid(pid, os.WNOHANG)[0]: break
    time.sleep(0.2)
shutil.rmtree(home, ignore_errors=True)

# asciinema writes the command it ran into the header, with a path on the
# recording machine; players never use it, so it is taken out
with open(cast) as f:
    lines = f.read().split("\n")
head = json.loads(lines[0])
head.pop("command", None)
lines[0] = json.dumps(head, separators=(",", ":"))
with open(cast, "w") as f:
    f.write("\n".join(lines))
print(cast, os.path.getsize(cast), "bytes")
