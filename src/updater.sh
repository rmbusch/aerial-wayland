#!/bin/bash

get_4k_video_urls() {
    # The raw content URL for the JSON file
    raw_url="https://raw.githubusercontent.com/OrangeJedi/Aerial/master/videos.json"
    
    # Fetch the JSON content and process it with jq to extract 4K video URLs
    video_urls=$(curl -s "$raw_url" | \
        jq -r '.[] | select(.src.H2654k != null) | .src.H2654k' 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        printf "Error fetching or parsing JSON" >&2
        printf "Check the OrangeJedi Aerial repository -- repo may have moved." >&2
        return 1
    fi
    
    echo "$video_urls"
}

fetch_videos() {
    printf "Fetching videos from apple servers. This may take a while..."

    # Get all video URLs first and count them
    video_urls=$(get_4k_video_urls | sed 's/https:/http:/g')
    total_videos=$(echo "$video_urls" | wc -l)
    current=0
    downloaded=0

    for url in $video_urls; do
        current=$((current + 1))
        filename=$(basename "$url")
        if [ -f "$HOME/.local/share/aerial-wayland/videos/$filename" ]; then
            printf "\rFile exists, skipping $filename\n"
        else
            target_file="$HOME/.local/share/aerial-wayland/videos/$filename"
            mkdir -p "$(dirname "$target_file")"
            wget -q "$url" -O "$target_file"
            downloaded=$((downloaded + 1))
        fi
        printf "\r[%3d%%] Processing video %d/%d - Downloading..." $((current * 100 / total_videos)) "$current" "$total_videos"
    done
    printf "\r[100%%] Processing videos complete. %d video(s) processed, %d video(s) downloaded.\n" "$total_videos" "$downloaded"
    echo $downloaded
}

check_update_timeout() {
    #ask user if they want to update the timeout
    read -p "Do you want to update the timeout? (y/N) " update_timeout
    if [ "$update_timeout" == "y" ]; then
        read -p "Enter the new timeout (in minutes): " new_timeout
        echo "timeout=$new_timeout" > "$HOME/.local/share/aerial-wayland/aerial.config"
        echo 'updated'
    else 
        echo 'skipped'
    fi
}

updated_videos=$(fetch_videos)
updated_timeout=$(check_update_timeout)
# set string to 'Timeout updated' if timeout was updated, otherwise set to 'Timeout didn't change.'
if [ "$updated_timeout" == 'updated' ]; then
    timeout_string='Screensaver timeout updated'
else
    timeout_string="Timeout didn't change"
fi
printf "\n\n%s new video(s) downloaded. %s.\n" "$updated_videos" "$timeout_string" 
