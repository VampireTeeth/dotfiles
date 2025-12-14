#!/usr/bin/env bash

get_ime_status() {
    # fcitx5-remote prints the name of the active input method
    CURRENT_IME=$(fcitx5-remote -n)
    echo "$CURRENT_IME"
}

get_ime_status

