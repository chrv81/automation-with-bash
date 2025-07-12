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
$ ./v-downloader.sh
Running v-downloader script!
yt-dlp is installed.
Moving on to download process...

Please enter the video or audio URL to download:
Enter URL: https://example.com/video
Please enter the desired file title (without extension):
Enter text: my_video
Enter the directory to save the file (absolute path):
[Press Tab to autocomplete or Enter for current folder]
Your file is saved at: ./my_video.[extension]
```

## Notes

- The `[extension]` will be replaced by the actual file extension after download.
- If the directory does not exist, you will be prompted again.
- If `yt-dlp` is not installed, the script will install it for you.

## License

MIT

## Author

Chris
