#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="/etc/X11/xinit"
xclock="xclock"
xterm="xterm"
twm="twm"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$sysresources"
    else
        "$xrdb" -nocpp -merge "$sysresources"
    fi
fi

if [ -f "$sysmodmap" ]; then
    "$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$userresources"
    else
        "$xrdb" -nocpp -merge "$userresources"
    fi
fi

if [ -f "$usermodmap" ]; then
    "$xmodmap" "$usermodmap"
fi

# start some nice programs

if [ -d "$xinitdir"/xinitrc.d ] ; then
	for f in "$xinitdir/xinitrc.d"/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# "$twm" &
# "$xclock" -geometry 50x50-1+1 &
# "$xterm" -geometry 80x50+494+51 &
# "$xterm" -geometry 80x20+494-0 &
# exec "$xterm" -geometry 80x66+0+0 -name login

if [ -f ~/.xprofile ]; then
    . ~/.xprofile
fi

# Loop until  xorg is fully read to accept xrandr commands, then set the resolution
(
    attempts=0
    max_attempts=100
    while ! xrandr --query >/dev/null 2>&1; do
	if [ "$attempts" -ge "$max_attempts" ]; then
	    echo "[$(date)] Timeout: Xorg server never became ready for xrandr." >> ~/.xrandr.log
	    exit 1
	fi

	sleep 0.5
	attempts=$((attempts + 1))
    done

    #  run the configuration once xorg is ready
    if ! xrandr --output HDMI-0 --mode 2560x1440 2>> ~/.xrandr.log; then
	echo "[$(date)] xrandr command failed execution" >> ~/.xrandr.log
    fi
) &

exec i3
