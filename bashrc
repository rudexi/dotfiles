# 256colors
export TERM=xterm-256color

###########################
# Source global definitions
###########################

if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

#xmodmap
#xmodmap ~/.Xmodmap
#bind -f ~/.inputrc

########
# Colors
########

esc=$(printf '\033')
red="$esc[31m"
green="$esc[32m"
yellow="$esc[33m"
blue="$esc[34m"
magenta="$esc[35m"
cyan="$esc[36m"
grey="$esc[37m"
reset="$esc[m"
back="$esc[40m"
bold="$esc[1m"
underline="$esc[4m"

#######################
# Environment variables
#######################

export LANG=en_US.UTF-8
export EDITOR=vim
shopt -s globstar

export GOPATH=$HOME/.go

if $is_local; then
    PATH=$(echo \
        /usr/{,s}bin \
        /usr/local/{,s}bin \
        /{,s}bin \
        /usr/lib64/qt-3.3/bin \
        /opt/dell/srvadmin/bin \
        ~/.cabal/bin \
        ~/bin \
        ~/.local/bin \
        /opt/puppetlabs/bin \
    |tr ' ' ':')
fi

#########
# Aliases
#########

alias ls="ls --color"
alias ll="ls -l"
#alias tmux="env TERM=xterm-256color tmux"

alias kill_gnome="pkill --signal 3 -u ${USER} gnome-shell"

export HOSTALIASES=~/.hosts

alias nocurl="HTTPS_PROXY= HTTP_PROXY= http_proxy= https_proxy= ftp_proxy= curl"
alias tmc="tmux new-window tmc"

#########
# History
#########

HISTSIZE=1000000
HISTFILESIZE=1000000

################
# Programming
################

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

################
# Hostname color
################

color=$green
echo -ne "\033]0;$h\007"

############
# Git prompt
############

function prompter() {
    if [[ "$?" = 0 ]]; then
        exit_code="$green✔$reset"
    else
        exit_code="$red✘-$?$reset"; fi
    git_message=''
    rebase=false
    if [[ -d .git ]] || git rev-parse --is-inside-working-tree >/dev/null 2>&1; then
        git_branch=$(git branch|grep '*'|awk -F"* |" '{print $2}')
        if [[ $git_branch =~ 'HEAD' ]]; then
            branch="⭻ $(echo "$git_branch"|sed -e 's/[)]//'|awk '{print $NF}')"
        elif [[ $git_branch =~ 'rebasing' ]]; then
            branch="⚙$(echo "$git_branch"|sed -e 's/[)]//'|awk '{print $NF}')"
            rebase=true
        else
            branch="$(echo "$git_branch"|sed -e 's/[)]//'|awk '{print $NF}')"
        fi
        git_porcelain=$(git status --porcelain --branch)
        git_status=$(echo "$git_porcelain"|grep -v "^##")
        commit_status=$(echo "$git_porcelain"|grep '^##')
        staged=$(echo "$git_status"|grep -voP -c '^(.[MDU]|U.|DD|AA|[?][?]|$)')
        unstaged=$(echo "$git_status"|grep -oP -c '^.[MD]')
        nontracking=$(echo "$git_status"|grep -oP -c '^[?][?]')
        conflict=$(echo "$git_status"|grep -oP -c '^(U.|.U|DD|AA)')
        ahead=$(echo "$commit_status"|grep -oP 'ahead\s+\K[0-9]*' ) #sed 's/.*ahead \([0-9]*\).*/\1/')
        behind=$(echo "$commit_status"|grep -oP 'behind\s+\K[0-9]*' ) #sed 's/.*behind \([0-9]*\).*/\1/')
        stashed=$(git stash list|awk -F@ '{print $1}'|uniq -c|awk '{print $1}')
        gitafter=''
        gitbefore=''
        gitrebase=''
        if [[ ! -z $ahead ]]; then
            gitbefore+=" ↑$ahead"; fi
        if [[ ! -z $behind ]]; then
            gitbefore+=" ↓$behind"; fi
        if [[ ! -z $staged && $staged != 0 ]]; then
            gitafter+="$yellow●$staged$reset "; fi
        if [[ ! -z $unstaged && $unstaged != 0 ]]; then
            gitafter+="$blue✚$unstaged$reset "; fi
        if [[ ! -z $conflict && $conflict != 0 ]]; then
            gitafter+="$red✖$conflict$reset "; fi
        if [[ ! -z $nontracking && $nontracking != 0 ]]; then
            gitafter+="$cyan…$nontracking$reset "; fi
        if [[ ! -z $stashed ]]; then
            gitafter+="$magenta⚑$stashed$reset"; fi
        if [[ -z $gitafter ]]; then
            gitafter+="$green✔$reset"; fi
        if $rebase; then
           git_status=$(git status|grep -v -e "(use" -e "(see")
           git_rebase_before=$(echo -n "$git_status"|sed -n '/Last/,/Next/p'|grep -v '^[^ ]'|colrm 5|tr -d ' \n'|sed 's/p/-●/g'|sed 's/e/-◎/g'|sed 's/^-//')
           git_rebase_after=$(echo -n "$git_status"|sed -n '/Next/,/You/p'|grep -v '^[^ ]'|colrm 5|tr -d ' \n'|sed 's/p/-●/g'|sed 's/e/-◎/g')
           gitrebase="($blue$git_rebase_before$reset$grey$git_rebase_after$reset)"
        fi
        gitafter=$(echo "$gitafter"|sed -e 's/ $//')
        git_message="[$magenta$branch$reset$gitbefore$gitrebase|$gitafter]"
    fi
    export PS1="$exit_code \A ${cyan}\u${reset}@${color}\h${reset}:${yellow}\w${reset}${git_message}\n\$"
}

function logger() {
    echo "$(date -Iseconds) [$(tmux display-message -p '#W' 2>/dev/null)] ${USER} @ $(hostname -s) : $(dirs -0) $ $(history 1|cut -d' ' -f4-)" \
    >>~/.logs/bash_history.log
}

function prompt_command() {
    prompter
    logger
}

PROMPT_COMMAND=prompt_command

###########
# ls colors
###########

declare -A color_table=(
    # bold red (office files)
    ['1;31']="
        *.doc
        *.docx
        *.dot
        *.dotx
        *.fla
        *.pdf
        *.ppt
        *.pptx
        *.psd
        *.rtf
        *.xls
        *.xlsx
        "
    # blue (directories and encrypted files)
    ['34']="
        *.3des
        *.aes
        *.asc
        *.enc
        *.gpg
        *.pgp
        di
        "
    # yellow (config)
    ['33']="
        *.cfg
        *.conf
        *.xml
        *.yaml
        *.yml
        "
    # purple (artifacts)
    ['36']="
        *.pyc
        *.o
        "
    # bold purple (compressed or packaged)
    ['1;36']="
        *.7z
        *.apk
        *.deb
        *.dmg
        *.gem
        *.gz
        *.iso
        *.jar
        *.rar
        *.rpm
        *.tar
        *.tgz
        *.war
        *.zip
        "
    # green (human readable)
    ['32']="
        *.0
        *.1
        *.2
        *.3
        *.4
        *.5
        *.6
        *.7
        *.8
        *.9
        *.C
        *.c
        *.cc
        *.csh
        *.css
        *.cxx
        *.el
        *.erb
        *.hs
        *.htm
        *.html
        *.java
        *.js
        *.l
        *.man
        *.md
        *.mkd
        *.n
        *.objc
        *.org
        *.p
        *.pdc
        *.php
        *.pl
        *.pm
        *.pod
        *.pp
        *.py
        *.rb
        *.rdf
        *.sh
        *.shtml
        *.tex
        *.txt
        *.vim
        *.xml
        *.zsh
        "
    # grey
    ['37']=""
    # cyan (symlink)
    ['36']="ln"
    # reverted cyan (broken symlink)
    ['7;36']="or"
)
list=$(set -f
list=''
for i_color in "${!color_table[@]}"; do for entry in ${color_table[${i_color}]}; do
    list+="$entry=${i_color}:"
done; done
echo "$list"
)
export LS_COLORS="$list"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
