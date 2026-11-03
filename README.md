# dotfiles

## Installation

1. Install `xcode` utilities
```sh
xcode-select --install
```

2. Clone this repo and Run `install.sh` script

```sh
git clone https://github.com/vekkele/dotfiles.git ~/dotfiles && cd ~/dotfiles && sh ~/dotfiles/install.sh
```

3. (Optional) Update git remote url for push with ssh
```
git remote set-url origin git@github.com:vekkele/dotfiles.git
```

## Ghostty and Herdr

Both configs are managed by GNU Stow and loaded from `~/.config`:

- `ghostty/.config/ghostty/config.ghostty` → `~/.config/ghostty/config.ghostty`
- `herdr/.config/herdr/config.toml` → `~/.config/herdr/config.toml`

To link just these packages from the repository root:

```sh
stow --target="$HOME" ghostty herdr
```

Before linking, back up any existing regular config files at those paths.
Keep Herdr's config directory in place: it also contains live sockets, logs,
and session state, which are not managed by Stow.

On macOS, also move any existing `config.ghostty` or legacy `config` out of
`~/Library/Application Support/com.mitchellh.ghostty/` so they cannot override
the [Ghostty XDG config](https://ghostty.org/docs/config#file-location).
The shell already sets `XDG_CONFIG_HOME="$HOME/.config"` in `zsh/.zshenv`;
Ghostty also uses this location when launched without that environment variable.

Validate the linked configs:

```sh
ghostty +validate-config
herdr config check
```

Reload Ghostty with `Cmd+Shift+,` and a running Herdr server with
`herdr server reload-config`.
