#!/bin/bash
#
# lib.sh: common code for bash A-code utilities
# This library provides shared functions for finding and managing
# A-code components, games, and build tools
#
# Set up directory paths for A-code environment
BIN=$(dirname $(which $0))      # Directory containing scripts
[ "$BIN" = '.' ] && BIN=$(pwd)  # Needed for MacOS compatibility
ADV=$(dirname $BIN)             # Main A-code directory
KDIR="$ADV/kernel"              # Default kernel directory
ADIR="$ADV/acdc"                # Default acdc directory
#
# Sanitize PATH to include only safe directories and emscripten
# This prevents issues with potentially malicious directories in PATH
cline="$@"    # Preserve the original command line
RIFS="$IFS"   # Save original field separator
IFS=:         # Use colon as field separator
set -- $PATH  # Split PATH into individual directories
IFS="$RIFS"   # Restore original field separator
# Rebuild PATH with only trusted directories
PATH=''
while [ $# -gt 0 ]; do
  case "$1" in
    /bin|/usr*|*/ems*)  # Allow system directories and emscripten
      [ -n "$PATH" ] && PATH="$PATH:"
      PATH="$PATH$1"
    ;;
    *) ;;  # Skip potentially unsafe directories
  esac
  shift
done
PATH="$PATH:$BIN"  # Add our bin directory
set -- $cline       # Restore original command line
#
#------------------------------------------------------------------------
# Filter directory list based on stability preference
# Args: stable_flag base_name dir_list...
# stable_flag: -1=unstable only, 0=all, 1=stable only
function stability()
{
  local stable=$1; shift   # Stability preference
  local name=$1; shift     # Base name to match
  local cnt=0
  local list="$@"          # Full list of directories
  
  while [ $# -gt 0 ]; do
    # For unstable preference, return exact match
    [ $stable != 1 ] && [ "$1" = "$name" ] && echo "$1" && return
    # For stable preference, return versioned directories
    [ $stable = 1 ] && [ "$1" != "$name" ] && echo "$1" && ((cnt++))
    shift
  done
  # For no preference, return everything
  [ $stable = 0 ] && echo "$list"
}
#--------------------------------------------------------------
# Find the latest version from a list of versioned directories
# Args: directory_list...
# Returns the directory with the highest version number
function latest()
{
  local list="$@"          # List of directories to examine
  local versions= cnt=0    # Versioned items and count
  local item=              # Current item being examined
  local min=0 maj=0        # Version number components
  # Extract only items with version numbers (format: name-major.minor)
  for item in $list; do
    case "$item" in
      *-[0-9]*.*[0-9]) versions="$versions $item"; ((cnt++)) ;;
      *) ;;  # Skip non-versioned items
    esac
  done
  # Return immediately if only one versioned item or no versioned items
  [ $cnt = 1 ] && echo $versions && return
  [ $cnt = 0 ] && echo $1 && return
  # Find the item with the highest version number
  local latest=
  for item in $versions; do
    # Split on dash and dot to extract version components
    RIFS="$IFS"; IFS="-."; set -- $item; IFS="$RIFS"
    while [ $# -gt 2 ]; do shift; done  # Keep only last two components
    
    # Compare major version
    [ "$1" -gt "$maj" ] && maj="$1" && latest="$item" && continue
    # Compare minor version if major versions match
    [ "$1" = "$maj" ] && [ "$2" -gt "$min" ] && min="$2" && latest="$item"
  done
  echo $latest
}
#--------------------------------------------------------------
# Find a utility (acdc or kernel) directory
# Args: stable_preference utility_name
function find_util()
{
  local stable=$1 util=$2 udir=
  cd $ADV
  # Collect all directories matching the utility name pattern
  for d in $util*; do udir="$udir $d"; done
  # Filter by stability preference
  udir=$(stability $stable $util $udir)
  # Find the latest version
  local got=$(latest $udir)
  [ -n "$got" ] && echo "$ADV/$got"
}
#--------------------------------------------------------------
# Find a game source file or directory
# Args: stable_preference game_name
# Searches in current dir, ADVDIR, ADV, and parent directories
function find_game()
{
  local dirs=". $ADVDIR $ADV $(dirname $ADV)" stable=$1 name=$2 is_file=0 
  local bare= item= gfil= gdir= fcnt= dcnt= got= d=
  # If name contains a path, check if it's a readable file
  case "$name" in
    */*) [ -f $name ] && [ -r $name ] && echo $name && return ;;
    *) ;;  # Name is just a basename, continue searching
  esac
  # Determine the base name to search for
  if [ -z "$name" ]; then
    # Use current directory name, stripping version suffix
    name=$(basename $(pwd))
    case "$name" in
      *-[0-9]*.*[0-9]) name=${name%-*} ;;  # Remove -version suffix
      *) ;;
    esac
    bare="$name"
  else
    # Strip .acd extension if present
    bare=${name%.acd}
    [ "$bare" != "$name" ] && is_file=1  # Remember if .acd was specified
  fi
  # Search in each directory
  cwd=$(pwd)
  for d in $dirs; do
    # Resolve relative directory references
    [ "$d" = '.' ] && d=$cwd
    [ "$d" = '..' ] && d=$(dirname $cwd)
    cd $d
    # Look for matching files and directories
    for item in *; do
      case "$item" in
        $bare.acd) gfil="$gfil $item" ;;        # Exact .acd file match
        $bare-*.acd) gfil="$gfil $item" ;;      # Versioned .acd file
        $bare) [ "$is_file" = 0 ] && [ -d "$item" ] && \
          gdir="$gdir $item" ;;                  # Exact directory match
        $bare-*) [ "$is_file" = 0 ] && [ -d "$item" ] && gdir="$gdir $item" ;;  # Versioned directory
        *) ;;  # No match
      esac
    done
    # Apply stability filtering and count results
    gfil=$(stability $stable $bare.acd $gfil)
    gdir=$(stability $stable $bare $gdir)
    set -- $gfil; fcnt=$#;  # Count files found
    set -- $gdir; dcnt=$#;  # Count directories found 
    # Prefer files over directories, then find latest version
    if [ $fcnt != 0 ]; then 
      got="$(latest $gfil)"    # Use latest .acd file
    elif [ $dcnt != 0 ]; then
      got="$(latest $gdir)"    # Use latest directory
    fi
    # If we found something, determine the exact file to return
    if [ -n "$got" ]; then
      if [ -d "$d/$got" ]; then
        # Found a directory - look for the main game file inside
        barest=${bare%-*}  # Remove any version suffix
        file=
        for f in "$d/$got"/*; do
          case "$f" in
            */$what) file="$what" ;;           # Exact match for requested name
            */$name) file="$name" ;;           # Match for specified name
            */$name.acd) file="$name.acd" ;;   # .acd version of specified name
            */$barest) file="$barest" ;;       # Base name without version
            */$barest.acd) file="$barest.acd" ;; # .acd version of base name
            */main.acd) [ -z "$file" ] && file=main.acd ;;  # Fallback to main.acd
            */game.acd) [ -z "$file" ] && file=game.acd ;;  # Fallback to game.acd
            *) ;;
          esac
        done
        [ -n "$file" ] && echo "$d/$got/$file" && return
      else
        # Found a file - return it directly
        [ -n "$got" ] && echo "$d/$got" && return
      fi
    fi
  done
  # Final fallback - look for main.acd or game.acd in current directory
  cd $cwd
  for f in main game; do
    [ -f $f.acd ] && echo $f.acd && return
  done
}
#--------------------------------------------------------------
# Main function to find any A-code component (utility or game)
# Args: stable_preference component_name
function find_it()
{
  local stable=$1 what=$2 game= d= file=
  case "$what" in
    acdc|kernel) echo $(find_util $stable $what); return ;;      # Find utilities
    acdc*|kernel*) echo $(find_util 0 $what); return ;;         # Specific versioned utilities
    *-[0-9]*.*[0-9]) game=$(find_game 0 $what) ;;              # Specific versioned game
    *) game=$(find_game $stable $what) ;;                       # Game with stability preference
  esac
  echo $game && return
}
#------------------------------------------------------------------------
#
# Find required libraries for linking
# Args: [architecture] library_name...
# Sets global variables: libs (link flags), mislib (missing libraries)
function findlibs()
{
  libarch=
  # Determine target architecture
  case "$1" in
    *64*) libarch=64; shift ;;  # 64-bit architecture
    *32*) libarch=32; shift ;;  # 32-bit architecture
    *) ;;  # Use system default
  esac
  # Auto-detect architecture if not specified
  if [ -z "$libarch" ]; then
    case "$(uname -m)" in
      *64*) libarch=64 ;;  # 64-bit system
      *)    libarch=32 ;;  # 32-bit or other
    esac
  fi
  # Initialize result variables
  libs=        # Successful library link flags
  nolib=       # Libraries not found in local directory
  mislib=      # Libraries missing entirely
  archdir=     # Architecture-specific directory
  # First try local architecture-specific library directory
  if [ -d "$ADV/lib$libarch" ]; then
    archdir="$ADV/lib$libarch"
    for lib in $@; do
      # Check for static library file
      [ -r $archdir/lib$lib.a ] && \
        libs="$libs -L$archdir -l$lib" || nolib="$nolib $lib"
    done
  else
    # No local library directory - will need to search system
    nolib="$@"
  fi
  # For libraries not found locally, search system directories
  if [ -n "$nolib" ]; then
    # Determine system library directory
    [ -d /usr/lib$libarch ] && archdir=/usr/lib$libarch || archdir=/usr/lib
    for lib in $nolib; do
      # Check if library is available via ldconfig
      case "$(ldconfig -vn $archdir 2>/dev/null| grep $lib)" in
        *lib$lib.so.*) libs="$libs -l$lib" ;;       # Found shared library
        *) mislib="$mislib $lib" ;;                  # Library not found
      esac
    done
  fi
#  libarch=
#  case "$1" in
#    *64*) libarch=64; shift ;;
#    *32*) libarch=32; shift ;;
#    *) ;;
#  esac
#  if [ -z "$libarch" ]; then
#    case "$(uname -m)" in
#      *64*) libarch=64 ;;
#      *)    libarch=32 ;;
#    esac
#  fi
#  [ "$libarch" = 32 ] && [ ! -d /usr/lib32 ] && libarch=
#  libs=
#  for lib in $@; do
#    libfile=
##    for dir in $ADV /usr /usr/local /opt/local; do
#    for dir in /usr /usr/local /opt/local; do
#      [ -r "$dir/lib$libarch/lib$lib.a" ] && \
#        libfile="$dir/lib$libarch/lib$lib.a" && break
#      for libfile in $dir/lib$libarch/lib$lib.so.*; do
#        [ -r "$libfile" ] && break || libfile=
#      done
#      [ -z "$libfile" ] || break
#    done
#    [ -z "$libfile" ] && mislib="$mislib $lib" || libs="$libs $libfile "
#  done
  # Set return values (eval prevents word splitting issues)
  eval "libs='$libs'"
  eval "mislib='$mislib'"
}
#--------------------------------------------------------------
# Extract version string from a quoted C #define line
# Args: define_line (e.g., '#define VERSION "1.23"')
function version()
{
  local RIFS="$IFS"
  IFS='"'      # Split on quotes
  set -- $1
  IFS="$RIFS"
  echo $2      # Second field is the version string
}
#--------------------------------------------------------------
# Extract kernel version from kernel source file
# Args: kernel_directory
function kversion()
{
  local kver=$(grep 'define KERNEL_VERSION' $1/adv00.c)
  echo $(version "$kver")
}
#--------------------------------------------------------------
# Extract acdc version from acdc source file
# Args: acdc_directory
function aversion()
{
  local aver=$(grep 'define ACDC_VERSION' $1/acdc.c)
  echo $(version "$aver")
}
#--------------------------------------------------------------
# Extract game version from .acd file
# Args: acd_file_path
function gversion()
{
  set -- $(grep -i '^Version' "$1")
  [ -n "$2" ] && echo $2 || echo UNKNOWN
}
#--------------------------------------------------------------
# Extract game date from .acd file
# Args: acd_file_path
function gdate()
{
  set -- $(grep -i '^Date' "$1")
  [ -n "$2" ] && echo $2 $3 $4 || echo UNKNOWN
}
#--------------------------------------------------------------
# Test function to find acdc, kernel, and a named component
# Args: [-s|-u] component_name
function libtest()
{
  stable=0
  name="$1"
  # Parse stability option
  case "$name" in
    -s*) stable=1; name="$2" ;;   # Stable preference
    -u*) stable=-1; name="$2" ;;  # Unstable preference
    *) ;;                          # No preference
  esac
  # Find and display paths
  echo $(find_it $stable 'acdc')
  echo $(find_it $stable 'kernel')
  echo $(find_it $stable "$name")
}
#--------------------------------------------------------------
# Parse command line arguments, expanding combined short options
# Args: mandatory_arg_chars remaining_args...
# E.g., comline 'al' -xvf file  =>  -x -v -f file
function comline()
{
  local marg="$1"   # List of short option chars that take mandatory arguments
  shift
  local kwrd key
  
  while [ $# != 0 ]; do           # Process each command line token
    case "$1" in
      --*) echo ${1/=/ }' ' ;;    # Long option: convert --opt=val to --opt val
      -*) kwrd=${1:1}             # Short option(s): strip the leading '-'
          while [ -n "$kwrd" ]; do    # Process each character in the option group
            key=${kwrd:0:1}       # Extract first character
            kwrd=${kwrd:1}        # Remove first character from remaining
            echo "-$key "         # Output the individual short option
            # Check if this option requires an argument
            if [ -n "$marg" ] && [[ $key =~ [$marg] ]]; then
              echo $kwrd          # Output remaining characters as the argument
              break;              # Done with this token
            fi
          done ;;                 # Done with this group of short options
      *) echo -n "$1 " ;;         # Regular argument - output as-is
    esac
    shift                         # Move to next token
  done
}
#
#################################################################
