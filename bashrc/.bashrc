#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Created by `pipx` on 2025-12-13 07:31:00
export PATH="$PATH:$HOME/.local/bin"

# Check if the 'neofetch' command exists before running it as a banner
if command -v neofetch >/dev/null 2>&1; then
    neofetch
fi
