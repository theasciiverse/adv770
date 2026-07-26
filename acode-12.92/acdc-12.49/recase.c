 /* recase.c (acdc) - copyright Mike Arnautov 1990-2025.
  * Licensed under GPL, version 3 or later (see the supplied LICENCE file).
  *
  * 24 Apr 2023  MLA           Complete re-coding. Now can use utf8proc.
  */
  
#include <string.h>
#include <stdio.h>

#ifdef HAVE_UTF8

#include "utf8proc.h"
void recase(int newcase, char *strin, char *strout, int maxlen)
{
  char *buf;
  if (newcase == 'L')
    buf = utf8proc_NFKC_Casefold (strin);
  else
  {
    char *bp;
    int len;
    buf = malloc (maxlen + 4); /* 1 extra code point */
    bp = buf;
    int uval;

    while (*strin && (bp - buf < maxlen))
    {
      len = utf8proc_iterate (strin, -1, &uval);
      strin += len;
      if (newcase != '-')
        uval = utf8proc_toupper (uval);
      len = utf8proc_encode_char (uval, bp);
      bp += len;
      if (newcase == 'C') newcase = '-';
    }
    *bp = '\0';
  }
  strncpy (strout, buf, maxlen - 1);
  *(strout + maxlen - 1) = '\0'; /* In case it got chopped */
  free (buf);
}

#else /* !HAVE_UTF8 */

void recase (int newcase, char *strin, char *strout, int dummy)
{
  while (*strin)
  {
    if (newcase == 'L' && *strin >= 'A' && *strin <= 'Z')
      *strout++ = (*strin++) + 32;
    else if (newcase == 'U' && *strin >= 'a' && *strin <= 'z')
      *strout++ = (*strin++) - 32;
    else if (strin != strout)
      *strout++ = *strin++;
    else
      { strin++; strout++; }
  }
  *strout = '\0';
}

#endif /* !UTF8 */
