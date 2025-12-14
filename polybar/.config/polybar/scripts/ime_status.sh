#!/usr/bin/env bash

get_ime_status() {
    # fcitx5-remote prints the name of the active input method
    CURRENT_IME=$(fcitx5-remote)

    if [ "$CURRENT_IME" = "keyboard-us" ] || [ "$CURRENT_IME" = "keyboard-dvorak" ]; then
        echo "EN"
    elif [ "$CURRENT_IME" = "pinyin" ]; then
        echo "CN"
    else
        # Fallback for other IMEs or error status
        echo "??"
    fi
}

get_ime_status

