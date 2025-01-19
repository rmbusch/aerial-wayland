#!/bin/bash

video_dir="$HOME/.local/share/aerial-wayland/videos"
# read timeout (in minutes) from a plain text file 'aerial.config' and multiply by 60 to get seconds
timeout=$(grep "timeout=" "$HOME/.local/share/aerial-wayland/aerial.config" | cut -d'=' -f2)
timeout=$((timeout * 60))

cleanup() {
    pkill mpv
    pkill swayidle
    pkill yad
    exit 0
}

trap cleanup SIGTERM SIGINT

cmd="mpv --no-audio --really-quiet --speed=0.5 --stop-screensaver=no --panscan=1.0 -fs --shuffle --playlist='$video_dir' & disown"

# Run swayidle without exec to allow trap to work
swayidle -w \
    timeout $timeout "$cmd" \
    resume 'pkill mpv' &

# Wait indefinitely while still allowing signals to be caught
wait
