#!/bin/bash

install_dir="$HOME/.local/share/aerial-wayland"

get_4k_video_urls() {
    # The raw content URL for the JSON file
    raw_url="https://raw.githubusercontent.com/OrangeJedi/Aerial/master/videos.json"
    
    # Fetch the JSON content and process it with jq to extract 4K video URLs
    video_urls=$(curl -s "$raw_url" | \
        jq -r '.[] | select(.src.H2654k != null) | .src.H2654k' 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo "Error fetching or parsing JSON" >&2
        echo "Check the OrangeJedi Aerial repository -- repo may have moved." >&2
        return 1
    fi
    
    echo "$video_urls"
}

check_dependencies() {
    echo "Setting up aerial-wayland..."
    echo "Checking dependencies..."

    # Check if swayidle is installed, if not, notify and exit
    if ! command -v swayidle &> /dev/null; then
        echo "swayidle is not installed. Please install swayidle before setting up aerial-wayland."
        exit 1
    fi

    # Check if mpv is installed, if not, notify and exit
    if ! command -v mpv &> /dev/null; then
        echo "mpv is not installed. Please install mpv before setting up aerial-wayland."
        exit 1
    fi

    echo "All dependencies are installed."
}

fetch_videos() {
    echo "Fetching videos from apple servers. This may take a while..."

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

    echo -e "\nAll videos fetched from apple servers."
}

set_update_timeout() {
    #ask user if they want to update the timeout
    read -p "How many minutes should the screensaver timeout be? (default is 3)  " timeout
    echo "timeout=$timeout" > "$HOME/.local/share/aerial-wayland/aerial.config" 
    echo "Screensaver timeout set to $timeout minutes."
}

move_scripts() {
    cp ./src/main.sh "$install_dir/aerial-wayland.sh"
    cp ./src/updater.sh "$install_dir/aerial-update.sh"
    chmod +x "$install_dir/aerial-update.sh"
    chmod +x "$install_dir/aerial-wayland.sh"
    echo "Scripts installed and configuration initialized in $install_dir"
}

check_dependencies
sleep 1
fetch_videos
sleep 1
set_update_timeout
sleep 1
move_scripts
printf "SUCCESS: Aerial-wayland setup complete.\n"
