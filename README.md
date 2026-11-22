# pi-factory-daemon-brew-formular

Homebrew tap for the [pi-factory](https://github.com/MarvinPahling/pi-factory) mission daemon (`missiond`).

## Install

```sh
brew tap marvinpahling/pi-factory-daemon-brew-formular https://github.com/MarvinPahling/pi-factory-daemon-brew-formular
brew install --HEAD pi-factory-daemon
```

The formula is HEAD-only: it installs the latest `main` of pi-factory and runs the daemon with Homebrew's Node. A versioned release will follow once pi-factory is tagged.

Run `missiond` in a separate terminal. A launchd service is planned (roadmap M9) and is not part of this formula yet.
