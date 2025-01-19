# Aerial Wayland

A barebones screensaver for Wayland compositors that displays Apple TV's aerial videos.

## Overview

Aerial Wayland downloads and displays high-quality aerial footage from Apple TV. It uses `swayidle` for idle detection and `mpv` for video playback, making it a lightweight solution for Wayland-based Linux systems.

## Prerequisites

- `swayidle`: For idle detection
- `mpv`: For video playback
- `wget`: For downloading videos
- `jq`: For JSON parsing
- `curl`: For fetching video metadata
- `yad`: For system tray icon (optional)

## Installation

1. Clone this repository:

```bash
git clone https://github.com/rmbusch/aerial-wayland.git
cd aerial-wayland
```

2. Run the setup script:

```bash
./aerial-setup.sh
```

The setup script will:
- Check for required dependencies
- Create necessary directories
- Download aerial videos in 4K quality
- Set up configuration files
- Install the screensaver scripts

## Configuration

The screensaver timeout can be configured during installation or by editing:

```bash
~/.local/share/aerial-wayland/aerial.config
```

Default installation directory: `~/.local/share/aerial-wayland/`
Videos are stored in: `~/.local/share/aerial-wayland/videos/`

## Usage

To start the screensaver:

```bash
~/.local/share/aerial-wayland/aerial-wayland.sh
```

The screensaver will:
- Monitor for system idle using swayidle
- Play random aerial videos when system becomes idle
- Stop playback when activity is detected

### Other Wayland Compositors
Add the script to your autostart configuration according to your desktop environment's requirements.

## Updating Videos

To update the video collection:

```bash
~/.local/share/aerial-wayland/aerial-update.sh
```

## Credits

- Apple TV aerial videos provided by Apple
- Video metadata sourced from [OrangeJedi's Aerial repository](https://github.com/OrangeJedi/Aerial)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.