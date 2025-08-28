# v-downloader

A Bash script to download videos or audio from a URL using [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) and save them in a Logic Pro compatible format. The script works on macOS, Linux, and Windows (with WSL).

## Features

- Automatically installs `yt-dlp` if not present
- Prompts for video/audio URL, output file name, and save directory
- Supports tab-completion for directory input
- Validates user input for URL and directory
- Saves the downloaded file in the specified location

## Requirements

- Bash (macOS, Linux, or Windows WSL)
- `yt-dlp` (installed automatically if missing)
- `ffmpeg` (optional, for format conversion)

## Usage

```bash
./v-downloader.sh
```

### Steps

1. **Enter the video or audio URL**  
   Must start with `http://` or `https://`.

2. **Enter the desired file title**  
   Do not include the file extension.

3. **Enter the directory to save the file**

   - Use tab for auto-completion.
   - Leave empty to save in the current folder.

4. The script downloads the file and prints the save location.

## Example

```text
   _           ____  ____  _      _      _     ____  ____  ____ 
/ \ |\      /  _ \/  _ \/ \  /|/ \  /|/ \   /  _ \/  _ \/  _ \
| | //_____ | | \|| / \|| |  ||| |\ ||| |   | / \|| / \|| | \|
| \// \____\| |_/|| \_/|| |/\||| | \||| |_\| \_/|| |-||| |_/|
\__/        \____/\____/\_/  \|\_/  \|\____/\____/\_/ \|\____/



(c) Copyright - Chris (Viettu) 2025 - All rights reserved.


================== USER AGREEMENT ==================

By using this script, you agree to comply with all applicable copyright laws and the terms of service of the platforms from which you download content.
This script is intended for use with videos that are either in the public domain or licensed under Creative Commons.
You are solely responsible for ensuring that your use of this script complies with all relevant laws and regulations.
The author of this script assumes no responsibility for any misuse or illegal activities conducted using this tool.
Please use this script ethically and respect the rights of content creators.

================== DISCLAIMER ==================

The developer of this script is not responsible for any legal issues arising from the misuse of this tool.
Nor the developer is affiliated with or endorsed by any video hosting platforms.
Users are encouraged to verify the copyright status of any content before downloading or using it.
Always seek permission from content creators when in doubt.

=========================================================

yt-dlp is not installed.
Installing yt-dlp...
yt-dlp installed successfully!
Moving on to download process.

Please enter the video or audio URL to download:
URL: 
```

## Notes

- The `[extension]` will be replaced by the actual file extension after download.
- If the directory does not exist, you will be prompted again.
- If `yt-dlp` is not installed, the script will install it for you.

## License

MIT

## Author

Chris
