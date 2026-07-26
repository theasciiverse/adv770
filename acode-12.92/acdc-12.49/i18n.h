/* i18n.h (acdc) - copyright Mike Arnautov 1990-2025.
 * Licensed under GPL, version 3 or later (see the supplied LICENCE file).
 *
 * 18 Jul 23   MLA             Initial coding
 *
 * Defines default kernel messages. These can be overriden by game code
 * by defining texts. Some (e.g. .k.in progress) cannot be morphed.
 *
 */
char *kernmsg[] = {
  ".k.data.dumped", "Game data dumped into the log file.\n",  
  ".k.exit.enter", "(To exit, press ENTER)\n",
  ".k.in.progress", "Restoring game in progress...\n\n",
  ".k.lost.session", "Oops! We seem to have lost your current game session! Sorry about that!\n",
  ".k.as.you.wish", "As you wish...\n",
  ".k.really.overwrite", "Do you really mean to overwrite it? ",
  ".k.already.have.name", "There's already a game dumped under that name.\n",
  ".k.changed.mind", "Changed your mind, eh? Fine by me...\n",
  ".k.name.to.restore", "Name of saved game to restore: ",
  ".k.game.list", "You have the following saved games: ",
  ".k.no.saved.games", "You have no saved games to restore.\n",
  ".k.name.to.save", "Name to save game under: ",
  ".k.yes.no", "Eh? Do me a favour and answer yes or no!\nWhich will it be? ",
  ".k.assume.yes", "(OK, smartass... I'll assume you mean YES - so there!)\n",
  ".k.ok", "OK.\n",
  ".k.more", "[More?] ",
  ".k.humanish", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  ".k.dwarvish", "bcdefghijklmnopqrstuvwxyzaBCDEFGHIJKLMNOPQRSTUVWXYZA",
  ".k.version", "version",
  ".k.submit", "Submit",
  ".k.browser.welcome", "Welcome to the A-code browser interface",
  ".k.browser.intro", 
    "<p>This interface can be used entirely from the keyboard, as long \
as the command input field remains in focus. Commands can be submitted \
by pressing the RETURN key and arrow keys can be used to recall and \
edit previous commands.</p> \
<p>The appearance of the game can be customized by modifying the A-code \
configuration file <b>acode.conf</b> &ndash; this can be found in \
the A-code directory, called either <b>.acode</b> or <b>acode</b>, \
within your home directory. There you can also find individual game \
directories called by the game name, which is where saved games and log \
files are stored by default.</p> \
<p>The configuration file has ample comments to guide you, should \
you decide to make any changes. If by any chance this interface \
does not work for you, you can change the browser specification in \
that file to NONE and then run the game in the console mode from a \
terminal window.</p>",
  ".k.browser.play", "Play",
  ".k.browser.coda", 
    "<p>(In case you are wondering why it is not possible to skip \
this intro page &ndash; it's because it is in fact a cunning workaround \
for a browser mis-feature, no names named. By clicking on the 'Play' \
button you will ensure that the browser behaves itself and gives \
keyboard focus to where the interface requests it to be.)</p>",
   ".k.http.intro", 
     "The game can be played entirely from the keyboard, as long as the \
  command input field remains in focus. Commands can be submitted by pressing \
  the ENTER key (a.k.a. RETURN). Arrow keys allow recalling/editing previous \
  commands. If you wish to stop playing and to continue at some other time, \
 it is not necessary to use the save command – just open this page again and \
 you will be offered the option of continuing the current game, if there is \
 one. The game runs locally on your machine – there is no network access. All \
 data storage relies on your browser's sand-boxed data store.",
   ".k.http.coda",
     "This JavaScript version of the game is made possible by the magic of",
   ".k.you.can", "You can",
   ".k.or.load", "or load a saved game",
   ".k.continue.game", "Continue your game",
   ".k.start.new.game", "Start a new game",
   ".k.or", "or",
   ".k.close.button", "Close this tab/window",
   ".k.browser.paranoid", 
     "(This will only work is your browser<br>is not being paranoid about security.)",
   ".k.wrong.version", "Wrong game version!",
   ".k.play.again", "Play again",
   ""                      /* End of kernel message definitions */
};

/*
// Sill to do in the kernel:
// .k.ok
// .k.more
// .k.wrong.version
//
*/
