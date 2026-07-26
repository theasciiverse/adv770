/* adv1.h: Adv770 - copyright Mike Arnautov 2026. Licensed under
 * GPL (version 3 or later) or the Modified BSD Licence, whichever
 * is asserted by the supplied LICENCE file.*/

#ifndef ADV1_H
#define ADV1_H
#define GAME_VERSION "2.33"
#define GAME_ID "Adv770 2.33, 17 Mar 2024"
#define STYLE 12
#ifndef ADV01
#define GAME_DATE "17 Mar 2024"
#define ACDC_VERSION "12.49, 10 Mar 2025"
#define GAME_NAME "Adv770"
#if defined(MSDOS) || defined(_WIN32)
#  define PERSISTENT_DATA "_adv770.adp"
#  define CGINAME "_adv770"
#else
#  define PERSISTENT_DATA ".adv770.adp"
#  define CGINAME ".adv770"
#endif
#define DBNAME "adv770.dat"
#define OBJSIZE 2
#define LOCSIZE 2
#define VARSIZE 1
#define _k_already_have_name 3510
#define _k_as_you_wish 3506
#define _k_assume_yes 3524
#define _k_browser_coda 3544
#define _k_browser_intro 3540
#define _k_browser_paranoid 3562
#define _k_browser_play 3542
#define _k_browser_welcome 3538
#define _k_changed_mind 3512
#define _k_close_button 3560
#define _k_continue_game 3554
#define _k_data_dumped 3499
#define _k_dwarvish 3532
#define _k_exit_enter 3501
#define _k_game_list 3516
#define _k_http_coda 3548
#define _k_http_intro 3546
#define _k_humanish 3530
#define _k_in_progress 3495
#define _k_lost_session 3504
#define _k_more 3528
#define _k_name_to_restore 3514
#define _k_name_to_save 3520
#define _k_no_saved_games 3518
#define _k_ok 3526
#define _k_or 3558
#define _k_or_load 3552
#define _k_play_again 3566
#define _k_really_overwrite 3508
#define _k_start_new_game 3556
#define _k_submit 3536
#define _k_version 3534
#define _k_wrong_version 3564
#define _k_yes_no 3522
#define _k_you_can 3550
#define FOBJ 3
#define LOBJ 194
#define FLOC 195
#define LLOC 703
#define FVERB 704
#define LVERB 1143
#define FVAR 1144
#define LVAR 1264
#define FTEXT 1264
#define LTEXT 3572
#define NOISE 19
#define BARRED 20
#define KNOT 115
#define COMMA -1140
#define SEMICOLON -1142
#define INHAND 703
#define HERE 1146
#define THERE 1147
#define STATUS 1178
#define ARG1 1144
#define ARG2 1145
#define ARG3 1263
#define UNDO 738
#define REDO 739
#define UNDO_STAT 1192
#define UNDO_INFO 4
#define UNDO_TRIM 5
#define UNDO_INV 6
#define UNDO_BAD 7
#define SCHIZOID 6
#define JUGGLED 6
#define MOVED 0
#define PLSCLARIFY 5
#define SEEN 4
#define AGAIN 724
#define ALL 3
#define EXCEPT 1139
#define TYPO 2557
#define IT 166
#define ADVCONTEXT 1180
#define DWARVEN 1262
#define DWARVISH     021
#define PROMPTED 4
#define FSPECIAL 723
#define LSPECIAL 743
#define FACT 704
#define LACT 722
#define FDIR 744
#define LDIR 756
#define SAY 730
#define NOWORD -1
#define BADWORD -2
#define AMBIGWORD -3
#define AMBIGTYPO -4
#define SCENEWORD -5
#define BADSYNTAX -6
#define NO_MATCH 98
#define NO_AMATCH 99
#define OBJ 0
#define LOC 1
#define VERB 2
#define TERSE 2
#define BRIEF 1
#define BEENHERE 4
#define PLAIN 0
#define DBSTATUS 0
#define LPROC 1144
#define KEY(X) (value[1144]==X || value[1145]==X)
#define INIT_PROC p1
#define REPEAT_PROC p2
#endif
#define SW_START     037
#define SW_BREAK     036
#define HOLDER       035
#define IGNORE_EOL   032
#define NEST_TEXT    031
#define QUOTE_START  030
#define TAG_START    027
#define TAG_END      026
#define NBSP         025
#define BLOCK_START  024
#define BLOCK_END    023
#define CENTRE_START 022
#define VHOLDER      020
#define UTF8         0
#define VOCAB_SIZE 1313
#define TEXT_BYTES 519451
#define USEQUERY 0
#endif
