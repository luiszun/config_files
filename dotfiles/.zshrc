# vim: set filetype=zsh foldmethod=marker
# path settings
typeset -a path_entries
path_entries+=/usr/local/bin
path_entries+=/usr/local/sbin
path_entries+=/usr/bin
path_entries+=/bin
path_entries+=/usr/sbin
path_entries+=/sbin
path_entries+=/apollo/env/SDETools
path_entries+=/apollo/env/envImprovement
path_entries+=/opt/rh/devtoolset-2/root/usr/bin
path_entries+=/opt/rh/devtoolset-3/root/usr/bin
path_entries+=/usr/local/python3/bin
path_entries+=$HOME/.bin
path_entries+=$HOME/.rvm/bin

for path_entry in $path_entries; do
    if [[ ${path[(i)$path_entry]} -gt ${#path} ]] && [[ -e $path_entry ]]; then
        path=($path_entry $path)
    fi
done

[[ -e /usr/local/opt/coreutils/libexec/gnubin ]] && path=(/usr/local/opt/coreutils/libexec/gnubin $path)
[[ -e /usr/local/opt/coreutils/libexec/gnuman ]] && MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
[[ -e $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# history
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
unsetopt share_history
HISTFILE=~/.history
HISTSIZE=15000
SAVEHIST=15000

# environment
export EDITOR='vim'

bindkey -e
#export VISUAL=$EDITOR
#export PAGER=less
#export LESS='-i'
unsetopt beep
#KEYTIMEOUT=1 #fast vi esc timeout


# completion
autoload -Uz compinit && compinit
setopt complete_aliases
setopt extended_glob
unsetopt nomatch
setopt autocd
#setopt correct #correct commands but not arguments
#setopt correct_all #correct commands and arguments
setopt rm_star_silent
#setopt auto_name_dirs
#setopt auto_pushd
#setopt pushd_ignore_dups

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=2
#zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' users dma root
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# plugins
source ~/.zsh/plugins/git.zsh


# aliases
alias ls="ls --color=auto"
alias ll="ls -lhHGF"
alias l="ls -AlhF"
alias sl=ls

alias grep="grep --color=auto"
alias g="grep"

alias cd/="cd /"
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias _="sudo"

alias md="mkdir -p"
alias rd="rmdir"

# functions
fpath=(~/.zsh/functions $fpath)

#non-github exports
source ~/.private_exports
# zle
# export WORDCHARS=${WORDCHARS//[\/]/} # remove / to that backward/forward-word doesn't jump over an entire path in one go
# this puts the terminal in application mode that $terminfo is valid
#function zle-line-init() {
#  [[ -n ${terminfo[smkx]} ]] && printf '%s' ${terminfo[smkx]}
#  #echoti smkx
#}
#function zle-line-finish() {
#  [[ -n ${terminfo[rmkx]} ]] && printf '%s' ${terminfo[rmkx]}
#  #echoti rmkx
#}
#zle -N zle-line-init
#zle -N zle-line-finish
#autoload -U edit-command-line
#zle -N edit-command-line
#bindkey '\C-x\C-e' edit-command-line







# prompt & colors
# test prompt strings with print -rP '<prompt-string>'
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:git*' formats "%{$fg[blue]%}(%b)%{$reset_color%}%m%u%c%{$reset_color%}"
#zstyle ':vcs_info:git*' actionformats "%{$fg[blue]%}(%b)%{$fg[red]%}%a%{$reset_color%}%m%u%c%{$reset_color%}"
#zstyle ':vcs_info:git*' unstagedstr "%{$fg[yellow]%}⚡%{$reset_color%}"
#zstyle ':vcs_info:git*' stagedstr "%{$fg[magenta]%}↕}%{$reset_color%}"
autoload -Uz colors && colors # enable color, fg & bg variables to easily print colors
setopt prompt_subst # enable string substitution in prompt variables
[[ $TERM == "xterm" ]] && export TERM="xterm-256color"
[[ -e ~/.dotfiles/misc/dircolors ]] && eval $(dircolors ~/.dotfiles/misc/dircolors) # ls colors

# define left & right prompts
case $(hostname -s) in
    luiszun-desktop)
        host_prompt='%{$fg[cyan]%}luiszun-d'
        ;;
    sancho-lap)
         host_prompt='%{$fg[cyan]%}sancho-lap'
        ;;
esac

return_status='%{$fg[white]%}%(?..(%?%))%{$reset_color%}'
PS1="%{$reset_color%}${host_prompt}%{$fg[red]%}#%{$reset_color%} "
RPS1="%{$reset_color%}%{$fg[white]%}%(?..(%?%))%{$reset_color%}\$(git_prompt_info)%{$reset_color%} %{$fg[cyan]%}%3~%{$fg_bold[red]%} \$(date '+%H:%M:%S')%{$reset_color%}"
PS4='+%N:%i:%_>' # make debugging easier by adding %_ (context)





zmodload zsh/termcap
zmodload zsh/terminfo
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "^[[H"               beginning-of-line
bindkey "${terminfo[kend]}"  end-of-line
bindkey "^[[F"               end-of-line
bindkey "${terminfo[kich1]}" overwrite-mode
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char
bindkey "${terminfo[kpp]}"   up-line-or-history
bindkey "${terminfo[knp]}"   down-line-or-history
bindkey ' ' magic-space

