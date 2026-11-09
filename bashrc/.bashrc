#
# ~/.bashrc
#
path_add() {
    local dir="$1"
    # Ensure the directory exists and is not already in PATH
    if [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]]; then
        PATH="${PATH:+$PATH:}$dir"
        export PATH
    fi
}   

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Check if the 'neofetch' command exists before running it as a banner
if command -v neofetch >/dev/null 2>&1; then
    neofetch
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ensure ~/.local/bin is on PATH
path_add "$HOME/.local/bin"
# Ensure Cross-compiler GCC is on PATH
path_add "$HOME/opt/cross/bin"

# Set up starship
eval -- "$(/usr/sbin/starship init bash --print-full-init)"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# Set up zoxide (cd alternative)
eval "$(zoxide init bash)"
. "$HOME/.cargo/env"
