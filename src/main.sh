#!/bin/bash

aerial_dir="$HOME/.local/share/aerial-wayland"  
video_dir="$aerial_dir/videos"
# read timeout (in minutes) from a plain text file 'aerial.config' and multiply by 60 to get seconds
timeout=$(grep "timeout=" "$aerial_dir/aerial.config" | cut -d'=' -f2)
timeout=$((timeout * 60))
playback_speed=1.0 # Need to play with settings to get slower playback without stuttering

cleanup() {
    pkill mpv
    pkill swayidle
    exit 0
}

trap cleanup SIGTERM SIGINT

cmd="mpv --no-audio --no-osc --framedrop=no --video-sync=display-resample --really-quiet --speed=$playback_speed --stop-screensaver=no --panscan=1.0 -fs --shuffle --playlist='$video_dir' & disown"

swayidle -w \
    timeout $timeout "$cmd" \
    resume 'pkill mpv' \
    before-sleep 'pkill mpv' \
    lock 'pkill mpv' &

# Wait indefinitely while still allowing signals to be caught
wait