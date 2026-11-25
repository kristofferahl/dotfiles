# Rex

Config for [Rex](https://www.superlogical.com/rex/docs). It keeps Rex's default shortcuts and only adds a few extras.

## Setup

The Rex server reads `~/.config/rex/init.lua`, so symlink this whole folder there:

```bash
ln -s "$DOTFILES_DIR/.config/rex" ~/.config/rex
rex config reload
```

Link the folder, not just `init.lua`: `require` looks for `plugins/` and `lib/` next to
the symlink, so a file-only link can't find them.

### Why a symlink?

Rex supports `REX_CONFIG` and `XDG_CONFIG_HOME`, but only in the environment of the **Rex server process**. On macOS the app starts the server, not your shell, so exporting either one in `.zshrc` has no effect. You could use `launchctl setenv REX_CONFIG ...`, but that is lost on reboot and needs a full Rex restart. The symlink is simpler.

## Layout

```text
init.lua          # Rex defaults + requires each plugin
lib/util.lua      # shared helpers (current_dir, PATH for rex.exec, short_path)
plugins/*.lua     # one feature per file; add one and require it in init.lua
```

## Usage

```bash
rex config check    # validate init.lua
rex config reload   # apply changes (Rex doesn't watch the file)
rex keymap          # show loaded bindings and diagnostics
```

## Extras

| Key           | Action                                           |
| ------------- | ------------------------------------------------ |
| `cmd+b`       | Toggle sidebar (default `cmd+/` can't be pressed on a Swedish layout) |
| `shift+cmd+b` | Bookmarks: add the current directory, or open (new tab / new session / cd) or remove one. Stored in `~/.local/share/rex/bookmarks.json` |
| `shift+cmd+o` | Pick a project with a `rex-dev.sh` (under `~/develop`), run it, and switch to its session |
| `shift+cmd+m` | Run `mavis --ai` in a floating pane              |
| `?` in copy mode | Toggle a list of copy mode keys (`shift+cmd+c` enters copy mode) |
| `alt+cmd+r`   | Resize mode: arrows/`hjkl`, `shift` for bigger steps, `=` balance, `esc`/`enter` exit |

Rex's default shortcuts are listed in the [Mac Actions reference](https://www.superlogical.com/rex/docs/reference/mac-actions).
