# ScreenRecorder
Record any iOS device connected with USB to a Mac

```
USAGE: record-command [--verbose] [--udid <udid>] --output <output> [--fps <fps>] [--quality <quality>]

OPTIONS:
  -v, --verbose           Enable verbose mode
  -u, --udid <udid>       Device's UDID
  -o, --output <output>   Output file
  -f, --fps <fps>         Video FPS (default: 60)
  -q, --quality <quality> Video Quality [low/medium/high] (default: high)
  -h, --help              Show help information.
```

## Installation

* Install [homebrew](https://brew.sh).
* Install [mint](https://github.com/yonaskolb/Mint) with homebrew (`brew install mint`).
* From command line: `mint install itaybre/screenrecorder`

## Build notes

* This project includes a build phase that writes to /usr/local/bin
* Make sure your /usr/local/bin is writable: `chmod u+w /usr/local/bin`
