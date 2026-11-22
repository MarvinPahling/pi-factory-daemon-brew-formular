# pi-factory-daemon-brew-formular

Homebrew tap for the [pi-factory](https://github.com/MarvinPahling/pi-factory) mission daemon (`missiond`).

## Install

```sh
brew tap marvinpahling/pi-factory-daemon-brew-formular https://github.com/MarvinPahling/pi-factory-daemon-brew-formular
brew install --HEAD pi-factory-daemon
```

The formula is HEAD-only: it installs the latest `main` of pi-factory and runs the daemon with Homebrew's Node. A versioned release will follow once pi-factory is tagged.

## Run

Start the daemon as a launchd user agent that starts at login and restarts after a crash:

```sh
brew services start pi-factory-daemon
```

Logs go to `$(brew --prefix)/var/log/missiond.log`. To run in the foreground instead, use `missiond`.

The service restarts the daemon only when it crashes (exits on a signal). When the daemon refuses to start because an execution safety inspection is required, it stays down. Stop the service, inspect surviving commands and external effects, run `missiond --acknowledge-execution-safety` once by hand, stop it, then start the service again. Never put the acknowledgment flag in the service definition.
