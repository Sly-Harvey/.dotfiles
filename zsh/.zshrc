# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh/

# Path to powerlevel10k theme
source $HOME/powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=(git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting Cmaker aliases z)
source $ZSH/oh-my-zsh.sh

# Key Bindings
bindkey -s ^t "tmux-find\n"
bindkey -s ^l "lf\n"
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# options
unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

function lf {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

function in {
    local pkg="$1"
    if pacman -Si "$pkg" &>/dev/null ; then
        sudo pacman -S "$pkg"
    else 
        "$aurhelper" -S "$pkg"
    fi
}

function cgen {
  mkdir $1
  cd $1
  touch CMakeLists.txt
  cat $ZSH/templates/ListTemplate.txt >> CMakeLists.txt
  mkdir src
  mkdir include
  touch src/main.cpp
  cat $ZSH/templates/HelloWorldTemplate.txt >> src/main.cpp
}

function crun {
  #VAR=${1:-.} 
  mkdir build 2> /dev/null
  cmake -B build
  cmake --build build
  build/main
}

function crun-mingw {
  #VAR=${1:-.} 
  mkdir build-mingw 2> /dev/null
  x86_64-w64-mingw32-cmake -B build-mingw
  make -C build-mingw
  build-mingw/main.exe
}

function cbuild {
  mkdir build 2> /dev/null
  cmake -B build
  cmake --build build
}

function cbuild-mingw {
  mkdir build-mingw 2> /dev/null
  x86_64-w64-mingw32-cmake -B build-mingw
  make -C build-mingw
}

# Helpful aliases
alias cls='clear'
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias zshrc='nvim ~/.zshrc'
alias vc='code --disable-gpu' # gui code editor
alias nv='nvim'
alias nf='neofetch'
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias bc="bc -ql"
alias mkd="mkdir -pv"
alias tp="trash-put"
alias tpr="trash-restore"
alias grep='grep --color=always'

# Directory Shortcuts.
alias nvimdir='cd ~/.config/nvim/'
alias dev='cd /mnt/seagate/dev/'
alias cppdir='cd /mnt/seagate/dev/C++/'
alias zigdir='cd /mnt/seagate/dev/Zig/'
alias csdir='cd /mnt/seagate/dev/C#/'
alias rustdir='cd /mnt/seagate/dev/Rust/'
alias pydir='cd /mnt/seagate/dev/Python/'
alias javadir='cd /mnt/seagate/dev/Java/'
alias luadir='cd /mnt/seagate/dev/lua/'
alias webdir='cd /mnt/seagate/dev/Website/'
alias seagate='cd /mnt/seagate/'
alias media='cd /mnt/seagate/media/'
alias games='cd /mnt/games/'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#Display Pokemon
#pokemon-colorscripts --no-title -r 1,3,6
