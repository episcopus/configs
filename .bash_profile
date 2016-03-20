# Started from Nathaniel Landau's file at https://natelandau.com/my-mac-osx-bash_profile/

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.  Environment Configuration
#  2.  Make Terminal Better (remapping defaults and adding functionality)
#  3.  File and Folder Management
#  4.  Searching
#  5.  Process Management
#  6.  Networking
#  7.  System Operations & Information
#  8.  Web Development
#  9.  Reminders & Notes
#
#  ---------------------------------------------------------------------------

# -------------------------------
# 1. ENVIRONMENT CONFIGURATION
# -------------------------------

# Change Prompt

# Color escape codes are at http://blog.taylormcgann.com/tag/prompt-color/
BLUE="\[\033[0;34m\]"
BRIGHT_BLUE="\[\033[0;94m\]"
BRIGHT_YELLOW="\[\033[0;93m\]"
BRIGHT_GREEN="\[\033[0;92m\]"
END_COLOR="\[\033[0m\]"

export PS1="$BRIGHT_GREEN\T$END_COLOR $BRIGHT_YELLOW\!$END_COLOR $BRIGHT_BLUE\W$END_COLOR$ "

# Set Paths
# ------------------------------------------------------------
export PATH="$PATH:/usr/local/bin/"
export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

# Set Default Editor (change 'emacs' to the editor of your choice)
# ------------------------------------------------------------
export EDITOR=/usr/bin/emacs

# Set default blocksize for ls, df, du
# from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
# ------------------------------------------------------------
export BLOCKSIZE=1k

# Add color to terminal
# (this is all commented out as I use Mac Terminal Profiles)
# from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
# ------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# -----------------------------
# 2. MAKE TERMINAL BETTER
# -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
# cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
# alias edit='subl'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n} | sort | uniq'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
alias grep='grep --color=auto'              # grep with color

# lr:  Full Recursive Directory Listing
# ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#         displays paginated result with colored search terms and two lines surrounding each hit.            Example: mans mplayer codec
# --------------------------------------------------------------------
mans () {
    man $1 | grep -iC2 --color=always $2 | less
}

# showa: to remind yourself of an alias (given some part of it)
# ------------------------------------------------------------
showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


# -------------------------------
# 3. FILE AND FOLDER MANAGEMENT
# -------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder

# cdf:  'Cd's to frontmost window of MacOS Finder
# ------------------------------------------------------
cdf () {
    currFolderPath=$( /usr/bin/osascript <<EOT
        tell application "Finder"
            try
        set currFolder to (folder of the front window as alias)
            on error
        set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell
EOT
    )
    echo "cd to \"$currFolderPath\""
    cd "$currFolderPath"
}

# extract:  Extract most know archives with one command
# ---------------------------------------------------------
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# ---------------------------
# 4. SEARCHING
# ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

# spotlight: Search for a file using MacOS Spotlight's metadata
# -----------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

# ---------------------------
# 5. PROCESS MANAGEMENT
# ---------------------------

# findPid: find out the pid of a specified process
# -----------------------------------------------------
#     Note that the command name can be specified via a regex
#     E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#     Without the 'sudo' it will only find processes of the current user
# -----------------------------------------------------
findPid () { lsof -t -c "$@" ; }

# memHogsTop, memHogsPs:  Find memory hogs
# -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# cpuHogs:  Find CPU hogs
# -----------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# topForever:  Continual 'top' listing (every 10 seconds)
# -----------------------------------------------------
alias topForever='top -l 9999999 -s 10 -o cpu'

# ttop:  Recommended 'top' invocation to minimize resources
# ------------------------------------------------------------
#     Taken from this macosxhints article
#     http://www.macosxhints.com/article.php?story=20060816123853639
# ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

# my_ps: List processes owned by my user:
# ------------------------------------------------------------
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


# ---------------------------
# 6. NETWORKING
# ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

# ii:  display useful host related informaton
# -------------------------------------------------------------------
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}

# ---------------------------------------
# 7. SYSTEMS OPERATIONS & INFORMATION
# ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

# cleanupDS:  Recursively delete .DS_Store files
# -------------------------------------------------------------------
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

# finderShowHidden:   Show hidden files in Finder
# finderHideHidden:   Hide hidden files in Finder
# -------------------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

# cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
# -----------------------------------------------------------------------------------
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#  screensaverDesktop: Run a screensaver on the Desktop
# -----------------------------------------------------------------------------------
alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

# ---------------------------------------
# 8. WEB DEVELOPMENT
# ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

# httpDebug:  Download a web page and show info on what took time
# -------------------------------------------------------------------
httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

# Prompting variables

# If you have seen enough experienced UNIX users at work, you may already have realized that the shell's prompt is not engraved in stone. Many of these users have all kinds of things encoded in their prompts. It is possible to put useful information into the prompt, including the date and the current directory.

# Actually , bash uses four prompt strings. They are stored in the variables PS1, PS2, PS3, and PS4. The first of these is called the primary prompt string; it is your usual shell prompt, and its default value is "\s-\v\$ ". Many people like to set their primary prompt string to something containing their login name. Here is one way to do this:
# PS1="\u--> "

# The \u tells bash to insert the name of the current user into the prompt string. If your user name is alice, your prompt string will be "alice—>". If you are a C shell user and, like many such people, are used to having a history number in your prompt string, bash can do this similarly to the C shell: if the sequence \! is used in the prompt string, it will substitute the history number. Thus, if you define your prompt string to be:
# PS1="\u \!--> "
# then your prompts will be like alice 1—>, alice 2—>, and so on.

# But perhaps the most useful way to set up your prompt string is so that it always contains your current directory. This way, you needn't type pwd to remember where you are. Here's how:
# PS1="\w--> "

# Table of prompt customizations that are available :
# \a  The ASCII bell character (007)
# \A  The current time in 24-hour HH:MM format
# \d  The date in "Weekday Month Day" format
# \D {format} The format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation; the braces are required
# \e  The ASCII escape character (033)
# \H  The hostname
# \h  The hostname up to the first "."
# \j  The number of jobs currently managed by the shell
# \l  The basename of the shell's terminal device name
# \n  A carriage return and line feed
# \r  A carriage return
# \s  The name of the shell
# \T  The current time in 12-hour HH:MM:SS format
# \t  The current time in HH:MM:SS format
# \@  The current time in 12-hour a.m./p.m. format
# \u  The username of the current user
# \v  The version of bash (e.g., 2.00)
# \V  The release of bash; the version and patchlevel (e.g., 2.00.0)
# \w  The current working directory
# \W  The basename of the current working directory
# \#  The command number of the current command
# \!  The history number of the current command
# \$  If the effective UID is 0, print a #, otherwise print a $
# \nnn    Character code in octal
# \\  Print a backslash
# \[  Begin a sequence of non-printing characters, such as terminal control sequences
# \]  End a sequence of non-printing characters

# PS2 is called the secondary prompt string; its default value is >. It is used when you type an incomplete line and hit RETURN, as an indication that you must finish your command.
