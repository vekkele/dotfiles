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

### Keyboard shortcuts

Ghostty sends `Ctrl+B` followed by a Herdr prefix command. The shortcuts use
physical key codes, so switching input layouts does not change their meaning.
These shortcuts are intended for a terminal running Herdr; they also send prefix
commands when Herdr is not running. Manually typed prefix commands still follow
the active input layout.

| Shortcut | Herdr action |
| --- | --- |
| `Cmd+T` | New tab |
| `Cmd+W` | Close pane |
| `Cmd+Shift+W` | Close tab and its panes |
| `Cmd+D` / `Cmd+Shift+D` | Split right / down |
| `Cmd+[` / `Cmd+]` | Previous / next pane |
| `Ctrl+Option+H/J/K/L` | Focus pane left / down / up / right |
| `Cmd+1…9` | Select tab |
| `Cmd+N` | New workspace |
| `Cmd+Shift+[` / `Cmd+Shift+]` | Previous / next workspace |
| `Cmd+Option+1…9` | Select workspace |
| `Cmd+Shift+Enter` | Toggle pane zoom |
| `Cmd+P` | Find a workspace, pane, or agent |

`Cmd+Option+W` is disabled to avoid closing a native Ghostty tab.
Create native Ghostty windows through its menu.

Manual commands start with `Ctrl+B`, followed by the command key:

- `?`: show keybindings; `q`: detach; `Shift+R`: reload Herdr config.
- `r`: enter pane resize mode. No direct pane resize shortcuts are added.
- `Shift+G`: create a Git worktree workspace; open existing worktrees from the
  Git workspace menu. Closing a workspace does not remove its worktree checkout.

System-wide `Caps+H/J/K/L` arrows and `Caps+Shift+H/J/K/L` selection are handled
by the Karabiner package.
