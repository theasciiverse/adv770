/* asciiverse.c: small platform helpers for the Asciiverse build of Adv770,
 * kept apart from the A-code kernel so that windows.h never meets its names.
 *
 * av_state_dir() names the player's state folder for the game, where the
 * config file, saved games, the interrupted-game state and the log live:
 * $XDG_STATE_HOME/<name>, else ~/.local/state/<name> (Linux and macOS), or
 * %LOCALAPPDATA%\<name> on Windows. av_make_dirs() creates a folder and its
 * parents. av_term_size() reads the terminal's size.
 *
 * Licensed like the rest of this package (GPL3 or later, see LICENCE).
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#if defined(_WIN32)
#  include <windows.h>
#  include <direct.h>
#  define AV_SEP '\\'
#  define av_mkdir(p) _mkdir (p)
#else
#  include <unistd.h>
#  include <sys/ioctl.h>
#  define AV_SEP '/'
#  define av_mkdir(p) mkdir ((p), 0700)
#endif

static char state_path [4096];

char *av_state_dir (const char *name)
{
   const char *base;

   if (*state_path)
      return (state_path);
#if defined(_WIN32)
   if ((base = getenv ("LOCALAPPDATA")) != NULL && *base)
      snprintf (state_path, sizeof (state_path), "%s\\%s", base, name);
   else if ((base = getenv ("USERPROFILE")) != NULL && *base)
      snprintf (state_path, sizeof (state_path),
         "%s\\AppData\\Local\\%s", base, name);
   else
      snprintf (state_path, sizeof (state_path), "%s", name);
#else
   if ((base = getenv ("XDG_STATE_HOME")) != NULL && *base == '/')
      snprintf (state_path, sizeof (state_path), "%s/%s", base, name);
   else if ((base = getenv ("HOME")) != NULL && *base)
      snprintf (state_path, sizeof (state_path), "%s/.local/state/%s",
         base, name);
   else
      snprintf (state_path, sizeof (state_path), "%s", name);
#endif
   return (state_path);
}

int av_make_dirs (const char *path)
{
   char buf [4096];
   char *cptr;
   struct stat sb;

   if (stat (path, &sb) == 0)
      return (0);
   snprintf (buf, sizeof (buf), "%s", path);
   for (cptr = buf + 1; *cptr; cptr++)
   {
      if (*cptr != '/' && *cptr != AV_SEP)
         continue;
#if defined(_WIN32)
      if (cptr == buf + 2 && buf [1] == ':')  /* the drive, C:\ */
         continue;
#endif
      *cptr = '\0';
      if (stat (buf, &sb) != 0 && av_mkdir (buf) != 0 && errno != EEXIST)
         return (-1);
      *cptr = AV_SEP;
   }
   if (av_mkdir (buf) != 0 && errno != EEXIST)
      return (-1);
   return (0);
}

/* The terminal's columns and rows, or 0 when they cannot be read (output
 * not a terminal, or no size reported). */

int av_term_size (int *cols, int *rows)
{
#if defined(_WIN32)
   CONSOLE_SCREEN_BUFFER_INFO info;

   if (!GetConsoleScreenBufferInfo (GetStdHandle (STD_OUTPUT_HANDLE), &info))
      return (0);
   *cols = info.srWindow.Right - info.srWindow.Left + 1;
   *rows = info.srWindow.Bottom - info.srWindow.Top + 1;
#else
   struct winsize ws;

   if (!isatty (1) || ioctl (1, TIOCGWINSZ, &ws) != 0)
      return (0);
   *cols = ws.ws_col;
   *rows = ws.ws_row;
#endif
   return (*cols > 0 && *rows > 0);
}
