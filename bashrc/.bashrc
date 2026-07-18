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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# Set up zoxide (cd alternative)
eval "$(zoxide init bash)"
