# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.chef-ninja ]; then
    . ~/.chef-ninja
fi

# ls after each cd
cd() {
  echo && builtin cd "$@" && _truncated_ls;
}
# but allow not ls'ing if we don't want to
bcd() {
  builtin cd "$@"
}

# Alias repeat x for running x over and over
function repeat() { while 1 ; do "$@" ; done; }

# a pretty ls truncated to at most N lines; helper function for cd, popd, pushd
_truncated_ls() {
    local LS_LINES=8 # use no more than N lines for ls output
    local RESERVED_LINES=5 # reserve N lines of the term, for short windows
    # eg. if a window is only 8 lines high, we want to avoid filling up the
    # whole screen, so instead only 3 lines would be consumed.

    # if using all N lines makes us go over the reserved number of lines
    if [[ $(($LINES - $RESERVED_LINES)) -lt $LS_LINES ]]; then
        local LS_LINES=$(($LINES - $RESERVED_LINES))
    fi

    # compute and store the result of ls
    local RAW_LS_OUT="$(command ls --group-directories-first \
                                   --format=across \
                                   --color=always \
                                   --width=$COLUMNS)"
    local RAW_LS_LINES=$(builtin echo -E "$RAW_LS_OUT" | wc -l)

    if [[ $RAW_LS_LINES -gt $LS_LINES ]]; then
        builtin echo -E "$RAW_LS_OUT" | head -n $(($LS_LINES - 1))
        _right_align "... $(($RAW_LS_LINES - $LS_LINES + 1)) lines hidden"
    else
        builtin echo -E "$RAW_LS_OUT"
    fi
}

# right align text and echo it; helper function for _truncated_ls
_right_align() {
    local PADDING=$(($COLUMNS - $(builtin echo "$1" | wc --chars)))
    if [[ $PADDING -gt 0 ]]; then
        for i in {1..$PADDING}; do
            builtin echo -n " "
        done
    fi
    builtin echo "$1"
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# rbenv aliases
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Git branch in command prompt
source /etc/bash_completion.d/git-prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\w\[\033[01;38m\]$(__git_ps1)\[\033[01;34m\]\$\[\033[00m\] '

export EDITOR=nano
